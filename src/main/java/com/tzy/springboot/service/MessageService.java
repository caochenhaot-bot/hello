package com.tzy.springboot.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.tzy.springboot.entity.Message;

import java.util.List;

/**
 * @BelongsProject: Software-Cup
 * @BelongsPackage: com.tzy.springboot.service
 * @Author: tengziyan
 * @CreateTime: 2023-07-29  15:45
 * @Description: TODO
 * @Version: 1.0
 */
public interface MessageService extends IService<Message> {

    void  saveMessage(Message message);
    void updateMessage(Message message);
}
