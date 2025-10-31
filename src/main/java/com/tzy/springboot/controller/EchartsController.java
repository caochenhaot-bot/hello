package com.tzy.springboot.controller;

import cn.hutool.core.date.DateUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.tzy.springboot.common.Result;
import com.tzy.springboot.entity.OnlineDate;
import com.tzy.springboot.mapper.ResultMapper;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.*;

@RestController
@RequestMapping("/echarts")
public class EchartsController {
    @GetMapping("/ping")
    public String ping() {
        System.out.println("== /echarts/ping hit ==");
        return "ok";
    }

    @Resource
    private ResultMapper resultMapper;

    /**
     * 统一接口：无参=全局统计；带 testfileId=按文件统计
     * 三类：0-正常，1-原发性，2-继发性
     */
    @GetMapping("/members")
    public Result members(@RequestParam(value = "testfileId", required = false) Integer testfileId) {
        List<Long> counts = new ArrayList<>();
        if (testfileId == null) {
            // 全局统计
            for (int i = 0; i < 3; i++) {
                counts.add(resultMapper.selectCount(
                        new LambdaQueryWrapper<OnlineDate>().eq(OnlineDate::getResult, i)
                ));
            }
        } else {
            // 按文件统计（直接使用列名，兼容实体字段名）
            counts = countByTestfileId(testfileId);
        }
        return Result.success(counts);
    }


    /** 兼容：查询参数版 */
    @GetMapping("/membersByFile")
    public Result membersByFileQuery(@RequestParam Integer testfileId) {
        return Result.success(countByTestfileId(testfileId));
    }

    /** 兼容：路径参数版 */
    @GetMapping("/members/{testfileId}")
    public Result membersByFilePath(@PathVariable Integer testfileId) {
        return Result.success(countByTestfileId(testfileId));
    }

    /** 只保留三类的分组明细（可视化辅助接口） */
    @GetMapping("/index")
    public Result index() {
        Map<Integer, List<OnlineDate>> map = new HashMap<>();
        for (int i = 0; i < 3; i++) {
            map.put(i, resultMapper.selectList(
                    new LambdaQueryWrapper<OnlineDate>().eq(OnlineDate::getResult, i)
            ));
        }
        return Result.success(map);
    }

    /** 累计预测样本数 */
    @GetMapping("/totle")
    public Result totle() {
        Long total = resultMapper.selectCount(new LambdaQueryWrapper<>());
        return Result.success(total);
    }

    /** 今日预测样本数 */
    @GetMapping("/totle1")
    public Result totle1() {
        List<OnlineDate> list = resultMapper.selectList(new QueryWrapper<>());
        String today = DateUtil.today();
        int n = 0;
        for (OnlineDate d : list) {
            if (d.getCreateTime() != null) {
                String day = DateUtil.format(d.getCreateTime(), "yyyy-MM-dd");
                if (today.equals(day)) n++;
            }
        }
        return Result.success(n);
    }

    /** 最常见高血压类型（返回 0/1/2） */
    @GetMapping("/totle3")
    public Result totle3() {
        Integer maxKey = null;
        long maxVal = -1;
        for (int i = 0; i < 3; i++) {
            long cnt = resultMapper.selectCount(
                    new LambdaQueryWrapper<OnlineDate>().eq(OnlineDate::getResult, i)
            );
            if (cnt > maxVal) {
                maxVal = cnt;
                maxKey = i;
            }
        }
        return Result.success(maxKey);
    }

    /* ---------- 内部方法 ---------- */

    /** 统计指定 testfileId 的三类数量 */
    private List<Long> countByTestfileId(Integer testfileId) {
        List<Long> counts = new ArrayList<>();
        for (int i = 0; i < 3; i++) {
            QueryWrapper<OnlineDate> w = new QueryWrapper<>();
            w.eq("result", i).eq("testfile_id", testfileId);
            counts.add(resultMapper.selectCount(w));
        }
        return counts;
    }
}
