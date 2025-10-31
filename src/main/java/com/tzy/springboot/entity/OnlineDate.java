package com.tzy.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.Date;

// com.tzy.springboot.entity.OnlineDate
@Data
@TableName("sys_result")
public class OnlineDate {
    @TableId(type = IdType.AUTO)
    private Integer id;

    private Integer testid;

    private Integer result;

    @ApiModelProperty("创建时间")
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    // ✅ 用驼峰命名，MyBatis-Plus 通过 @TableField 绑定真实列名
    @TableField("testfile_id")
    private Integer testfileId;
}

