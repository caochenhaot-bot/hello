package com.tzy.springboot.controller;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.io.FileUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tzy.springboot.common.Constants;
import com.tzy.springboot.common.Result;
import com.tzy.springboot.entity.OnlineDate;
import com.tzy.springboot.entity.TestFiles;
import com.tzy.springboot.mapper.ResultMapper;
import com.tzy.springboot.mapper.TestFileMapper;
import com.tzy.springboot.utils.PropertyUtil;
import com.tzy.springboot.utils.UsePythonUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import static com.tzy.springboot.utils.TokenUtils.getCurrentUser;

/**
 * 文件上传相关接口
 */
@RestController
@RequestMapping("/DataTest")
@Transactional
public class TestFileController {

    @Autowired
    private PropertyUtil propertyUtil;

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Autowired
    private TestFileMapper testFileMapper;

    @Autowired
    private ResultMapper resultMapper;

    @PostMapping("/upload")
    public Result upload(@RequestParam MultipartFile file) throws IOException, InterruptedException {
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
        File uploadFile = new File(propertyUtil.getPythonDataTestUpload() + fileUUID);
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
        url = "http://" + propertyUtil.getServerIp() + ":9090/DataTest/" + fileUUID;
        //获取当前用户的user_id
        String userId = stringRedisTemplate.opsForValue().get("userId");

        System.out.println("----------------------------------"+userId);
        // 存储数据库
        TestFiles saveFile = new TestFiles();
        saveFile.setName(originalFilename);
        saveFile.setType(type);
        saveFile.setSize(size/1024); // 单位 kb
        saveFile.setUrl(url);
        saveFile.setMd5(md5);
        saveFile.setUserid(Integer.parseInt(userId));
        testFileMapper.insert(saveFile);
        flushRedis(Constants.FILES_KEY);
        return Result.success();
    }

   // @Async
    @GetMapping("/getUrl/{url}")
    public Result debugging(@PathVariable String url) throws IOException {
        System.out.println("开始多线程,在线预测");
        // 根据文件的唯一标识码获取文件
        long stime = System.currentTimeMillis();
        // 执行时间（1s）
        LambdaQueryWrapper<TestFiles> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(TestFiles::getUrl,"http://localhost:9090/DataTest/"+url);
        TestFiles testFiles = testFileMapper.selectOne(queryWrapper);
        if (!ObjectUtil.isEmpty(testFiles.getEnable())){

            return Result.error("505","已完成，请查看结果");
        }
        File uploadFile = new File(propertyUtil.getPythonDataTestUpload() + url);
        String jsonUrl = UUID.randomUUID().toString();
        System.out.println(jsonUrl);
        System.out.println(uploadFile.toString());
        try{

            int i = UsePythonUtils.callPython(new String[] {
                    propertyUtil.getPythonExe(),propertyUtil.getPythonPredictMain(),
                    uploadFile.toString(),jsonUrl});
            System.out.println(i);
            if (i==1){
                return Result.error("507","预测失败");
            }
        }catch (InterruptedException e){
            throw new RuntimeException(e);
        }
        System.out.println("预测成功");
        testFiles.setEnable("1");
        testFiles.setJsonUrl(jsonUrl+".json");
        testFileMapper.updateById(testFiles);
        flushRedis(Constants.FILES_KEY);
        // 结束时间
        long etime = System.currentTimeMillis();
        // 计算执行时间
        System.out.printf("执行时长：%d 毫秒.", (etime - stime));
        System.out.println("结束多线程,在线预测结束");
        return Result.success();
    }

    /**
     * 分页查询接口
     * @param pageNum
     * @param pageSize
     * @param name
     * @return
     */
    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String name) {
        QueryWrapper<TestFiles> queryWrapper = new QueryWrapper<>();
        // 查询未删除的记录
        queryWrapper.eq("is_delete", false);
        queryWrapper.orderByDesc("id");
        if (!"".equals(name)) {
            queryWrapper.like("name", name);
        }
        return Result.success(testFileMapper.selectPage(new Page<>(pageNum, pageSize), queryWrapper));
    }

    // 设置缓存
    private void setCache(String key, String value) {
        stringRedisTemplate.opsForValue().set(key, value);
    }

    // 删除缓存
    private void flushRedis(String key) {
        stringRedisTemplate.delete(key);
    }


    @Transactional
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        LambdaQueryWrapper<OnlineDate> onlineDateLambdaQueryWrapper = new LambdaQueryWrapper<>();
        onlineDateLambdaQueryWrapper.eq(OnlineDate::getTestfileId,id);
        resultMapper.delete(onlineDateLambdaQueryWrapper);
        testFileMapper.deleteById(id);
        flushRedis(Constants.FILES_KEY);
        return Result.success();
    }


    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        QueryWrapper<OnlineDate> onlineDateQueryWrapper = new QueryWrapper<>();
        onlineDateQueryWrapper.in("testfile_id",ids);
        List<OnlineDate> onlinedates = resultMapper.selectList(onlineDateQueryWrapper);
        for (OnlineDate onlinedate:onlinedates){
            resultMapper.deleteById(onlinedate);
        }
        // select * from sys_file where id in (id,id,id...)
        QueryWrapper<TestFiles> queryWrapper = new QueryWrapper<>();
        queryWrapper.in("id", ids);
        List<TestFiles> testfiles = testFileMapper.selectList(queryWrapper);
        for (TestFiles file : testfiles) {
            testFileMapper.deleteById(file);
        }
        return Result.success();
    }

    @GetMapping("/detail/{id}")
    public Result getById(@PathVariable Integer id) {
        return Result.success(testFileMapper.selectById(id));
    }

    @GetMapping("/totle")
    public Result totle() {
        List<TestFiles> testfiles = testFileMapper.selectList(new QueryWrapper<TestFiles>());
        String today = DateUtil.today();
        Integer totle=0;
        for (TestFiles file : testfiles) {
            Date createTime = file.getCreateTime();
            String format = DateUtil.format(createTime, "yyyy-MM-dd");
            if (format.equals(today)){
                totle++;
            }

        }
        return Result.success(totle);
    }

    @GetMapping("/members/{id}")
    public Result members(@PathVariable Integer id) {
        System.out.println("---------------------"+id);
        ArrayList<Long> integers = new ArrayList<>();
        for (int i = 0; i < 6; i++) {
            LambdaQueryWrapper<OnlineDate> dateLambdaQueryWrapper = new LambdaQueryWrapper<>();
            dateLambdaQueryWrapper.eq(OnlineDate::getTestfileId,id);
            dateLambdaQueryWrapper.eq(OnlineDate::getResult, i);
            Long aLong = resultMapper.selectCount(dateLambdaQueryWrapper);
            integers.add(aLong);
        }
        System.out.println(integers.toString());
        return Result.success(integers);
    }
    @GetMapping("/totle/{id}")
    public Result totle(@PathVariable Integer id) {
        LambdaQueryWrapper<OnlineDate> dateLambdaQueryWrapper = new LambdaQueryWrapper<>();
        dateLambdaQueryWrapper.eq(OnlineDate::getTestfileId,id);
        Long aLong = resultMapper.selectCount(dateLambdaQueryWrapper);
        return Result.success(aLong);
    }

    @GetMapping("/{jsonUrl}")
    public void download(@PathVariable String jsonUrl, HttpServletResponse response) throws IOException {
        System.out.println(jsonUrl);
        // 根据文件的唯一标识码获取文件
        File uploadFile = new File(propertyUtil.getJsonDownload() + jsonUrl);
        // 设置输出流的格式
        ServletOutputStream os = response.getOutputStream();
        response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(jsonUrl, "UTF-8"));
        response.setContentType("application/octet-stream");
        // 读取文件的字节流
        os.write(FileUtil.readBytes(uploadFile));
        System.out.println("下载成功");
        os.flush();
        os.close();
    }



}
