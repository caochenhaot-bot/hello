package com.tzy.springboot.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.tzy.springboot.entity.User;
import com.tzy.springboot.controller.dto.UserDTO;
import com.tzy.springboot.controller.dto.UserPasswordDTO;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author 青哥哥
 * @since 2022-01-26
 */
public interface IUserService extends IService<User> {


    UserDTO login(UserDTO userDTO);

    User register(UserDTO userDTO);

    void updatePassword(UserPasswordDTO userPasswordDTO);

    Page<User> findPage(Page<User> objectPage, String username, String email, String address);

    void saveUpdateUser(User user);


}
