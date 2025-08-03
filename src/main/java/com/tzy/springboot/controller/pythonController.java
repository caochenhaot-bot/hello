package com.tzy.springboot.controller;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import com.auth0.jwt.JWT;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.tzy.springboot.entity.Files;
import com.tzy.springboot.entity.User;
import com.tzy.springboot.mapper.FileMapper;
import com.tzy.springboot.common.Constants;
import com.tzy.springboot.common.Result;
import com.tzy.springboot.service.IUserService;
import com.tzy.springboot.utils.TokenUtils;
import com.tzy.springboot.utils.UsePythonUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.List;
import java.util.UUID;

import static com.tzy.springboot.utils.TokenUtils.getCurrentUser;

/**
 * 文件上传相关接口
 */
@RestController
@RequestMapping("/python")
@Transactional
public class pythonController implements Runnable {

    @Value("${files.pythonupload.path}")
    private String fileUploadPath;
    @Value("${files.pythondownload.path}")
    private String fileDownloadPath;

    @Value("${server.ip}")
    private String serverIp;

    @Autowired
    private FileMapper fileMapper;

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    private static IUserService userService;

    /**
     * 文件上传接口
     * @param file 前端传递过来的文件
     * @return
     * @throws IOException
     */

    @PostMapping("/upload")
    public Result upload(@RequestParam MultipartFile file) throws IOException {
        String originalFilename = file.getOriginalFilename();
        String type = FileUtil.extName(originalFilename);
        long size = file.getSize();
        // 定义一个文件唯一的标识码
        String uuid="";
        synchronized (uuid) {
            uuid = (UUID.randomUUID().toString()).replace("-", "");
        }
        System.out.println(uuid);
        String fileUUID = uuid + StrUtil.DOT + type;
        System.out.println(fileUUID);
        File uploadFile = new File(fileUploadPath + fileUUID);
        // 判断配置的文件目录是否存在，若不存在则创建一个新的文件目录
        File parentFile = uploadFile.getParentFile();
        if(!parentFile.exists()) {
            parentFile.mkdirs();
        }
        String url;
        // 获取文件的md5
        String md5 = SecureUtil.md5(file.getInputStream());
        // 上传文件到磁盘
        file.transferTo(uploadFile);
        url = "http://" + serverIp + ":9090/python/" + fileUUID;
        //获取当前用户的user_id
        String userId = stringRedisTemplate.opsForValue().get("userId");

        System.out.println("----------------------------------"+userId);
        // 存储数据库
        Files saveFile = new Files();
        saveFile.setName(originalFilename);
        saveFile.setType(type);
        saveFile.setSize(size/1024); // 单位 kb
        saveFile.setUrl(url);
        saveFile.setMd5(md5);
        saveFile.setUserid(Integer.parseInt(userId));
        fileMapper.insert(saveFile);
        flushRedis(Constants.FILES_KEY);
        return Result.success();
    }

    //@Async
    @GetMapping("/getUrl/{url}")
    public Result debugging(@PathVariable String url) throws IOException {
        System.out.println("开始多线程,这是模型训练");
        // 根据文件的唯一标识码获取文件
        long stime = System.currentTimeMillis();
        // 执行时间（1s）
        LambdaQueryWrapper<Files> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(Files::getUrl,"http://localhost:9090/python/"+url);
        Files files = fileMapper.selectOne(queryWrapper);
        if (!ObjectUtils.isEmpty(files.getPythonurl())){
            return Result.error("505","已完成，请下载");
        }
        File uploadFile = new File(fileUploadPath + url);
        UsePythonUtils usePythonUtils = new UsePythonUtils();
        usePythonUtils.setPathOne(uploadFile.toString());
        System.out.println(uploadFile.toString());
        String pythonurl = url.replace("csv", "h5");
        System.out.println(pythonurl);
        usePythonUtils.setReslut(pythonurl);
        try {
            int i = usePythonUtils.UsePythontrain();
            System.out.println(i);
            if (i==1){
                return Result.error("507","训练失败");
            }

        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        System.out.println("训练成功");
        files.setPythonurl(pythonurl);
        fileMapper.updateById(files);
        flushRedis(Constants.FILES_KEY);
        // 结束时间
        long etime = System.currentTimeMillis();
        // 计算执行时间
        System.out.printf("执行时长：%d 毫秒.", (etime - stime));
        System.out.println("结束多线程,模型训练结束");
        return Result.success();
    }

    /**
     * 文件下载接口   http://localhost:9090/file/{fileUUID}
     * @param pythonUrl
     * @param response
     * @throws IOException
     */
    @GetMapping("/{pythonUrl}")
    public void download(@PathVariable String pythonUrl, HttpServletResponse response) throws IOException {
        System.out.println(pythonUrl);
        // 根据文件的唯一标识码获取文件
        File uploadFile = new File(fileDownloadPath+pythonUrl);
        // 设置输出流的格式
        ServletOutputStream os = response.getOutputStream();
        response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(pythonUrl, "UTF-8"));
        response.setContentType("application/octet-stream");
        // 读取文件的字节流
        os.write(FileUtil.readBytes(uploadFile));
        System.out.println("下载成功");
        os.flush();
        os.close();
    }


    /**
     * 通过文件的md5查询文件
     * @param md5
     * @return
     */
    private Files getFileByMd5(String md5) {
        // 查询文件的md5是否存在
        QueryWrapper<Files> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("md5", md5);
        List<Files> filesList = fileMapper.selectList(queryWrapper);
        return filesList.size() == 0 ? null : filesList.get(0);
    }

//    @CachePut(value = "files", key = "'frontAll'")
    @PostMapping("/update")
    public Result update(@RequestBody Files files) {
        fileMapper.updateById(files);
        flushRedis(Constants.FILES_KEY);
        return Result.success();
    }

    // 设置缓存
    private void setCache(String key, String value) {
        stringRedisTemplate.opsForValue().set(key, value);
    }

    // 删除缓存
    private void flushRedis(String key) {
        stringRedisTemplate.delete(key);
    }

    @Override
    public void run() {

    }
}
