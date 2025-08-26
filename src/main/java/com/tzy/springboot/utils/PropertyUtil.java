package com.tzy.springboot.utils;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
@Data
public class PropertyUtil {

    @Value("${files.pythonExe.path}")
    private String pythonExe;
    @Value("${files.pythonTrainMain.path}")
    private String pythonTrainMain;
    @Value("${files.pythonPredictMain.path}")
    private String pythonPredictMain;
    @Value("${files.pythonUpload.path}")
    private String pythonUpload;
    @Value("${files.pythonDataTestUpload.path}")
    private String pythonDataTestUpload;
    @Value("${files.pythonDownload.path}")
    private String pythonDownload;
    @Value("${files.JsonDownload.path}")
    private String jsonDownload;
    @Value("${server.ip}")
    private String serverIp;
}
