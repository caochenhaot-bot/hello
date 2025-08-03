package com.tzy.springboot.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tzy.springboot.entity.Message;
import org.apache.ibatis.annotations.Mapper;

/**
 * @BelongsProject: Software-Cup
 * @BelongsPackage: com.tzy.springboot.mapper
 * @Author: tengziyan
 * @CreateTime: 2023-07-29  15:07
 * @Description: TODO
 * @Version: 1.0
 */
@Mapper
public interface MessageMapper extends BaseMapper<Message> {
    int insertSelective(Message record);
}
