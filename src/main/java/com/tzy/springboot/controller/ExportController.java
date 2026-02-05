package com.tzy.springboot.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.tzy.springboot.entity.OnlineDate;
import com.tzy.springboot.mapper.ResultMapper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@RestController
@RequestMapping("/export")
public class ExportController {

    @Resource
    private ResultMapper resultMapper;

    /**
     * 导出指定 testfileId 的预测结果
     * 示例：
     *   /export/predict?testfileId=289&fmt=csv
     *   /export/predict?testfileId=289&fmt=json
     */
    @GetMapping("/predict")
    public void exportPredict(Integer testfileId, String fmt, HttpServletResponse resp) throws IOException {
        if (testfileId == null) {
            resp.sendError(400, "missing param: testfileId");
            return;
        }
        if (fmt == null || fmt.trim().isEmpty()) fmt = "csv";
        fmt = fmt.toLowerCase();

        List<OnlineDate> list = resultMapper.selectList(
                new QueryWrapper<OnlineDate>().eq("testfile_id", testfileId)
        );

        String baseName = "predict_" + testfileId;
        String fileName = baseName + "." + fmt;
        String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8.name()).replaceAll("\\+", "%20");

        if ("json".equals(fmt)) {
            // 你项目里用的 JSON 工具用哪个都行（fastjson/jackson）
            // 这里为了避免依赖冲突，简单拼一下。若要严格 JSON，请替换为项目的 JSON 工具。
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                OnlineDate d = list.get(i);
                json.append("{")
                        .append("\"id\":").append(safe(d.getId())).append(',')
                        .append("\"testid\":").append(safe(d.getTestid())).append(',')
                        .append("\"result\":").append(safe(d.getResult())).append(',')
                        .append("\"createTime\":\"").append(d.getCreateTime()==null?"":d.getCreateTime()).append("\",")
                        .append("\"testfileId\":").append(safe(d.getTestfileId()))
                        .append("}");
                if (i < list.size() - 1) json.append(",");
            }
            json.append("]");

            resp.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json;charset=UTF-8");
            resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);
            resp.getWriter().write(json.toString());
            resp.getWriter().flush();
            return;
        }

        // 默认 CSV
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/csv;charset=UTF-8");
        resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);

        PrintWriter w = resp.getWriter();
        // 表头可按需增减
        w.println("id,testid,result,create_time,testfile_id");
        for (OnlineDate d : list) {
            w.printf("%s,%s,%s,%s,%s%n",
                    safe(d.getId()),
                    safe(d.getTestid()),
                    safe(d.getResult()),
                    d.getCreateTime()==null ? "" : d.getCreateTime(),
                    safe(d.getTestfileId())
            );
        }
        w.flush();
    }

    private String safe(Object o) {
        return o == null ? "" : String.valueOf(o);
    }
}
