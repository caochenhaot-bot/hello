/*
 Navicat Premium Data Transfer

 Source Server         : 3306
 Source Server Type    : MySQL
 Source Server Version : 80012
 Source Host           : localhost:3306
 Source Schema         : soft_cup

 Target Server Type    : MySQL
 Target Server Version : 80012
 File Encoding         : 65001

 Date: 03/09/2024 15:12:35
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `value` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '内容',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '类型'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('coffee', 'el-icon-coffee\r\n', 'icon');
INSERT INTO `sys_dict` VALUES ('document', 'el-icon-document', 'icon');
INSERT INTO `sys_dict` VALUES ('house', 'el-icon-house', 'icon');
INSERT INTO `sys_dict` VALUES ('menu', 'el-icon-menu', 'icon');
INSERT INTO `sys_dict` VALUES ('s-custom', 'el-icon-s-custom', 'icon');
INSERT INTO `sys_dict` VALUES ('s-grid', 'el-icon-s-grid', 'icon');
INSERT INTO `sys_dict` VALUES ('s-marketing', 'el-icon-s-marketing', 'icon');
INSERT INTO `sys_dict` VALUES ('user', 'el-icon-user', 'icon');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '路径',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标',
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `pid` int(11) NULL DEFAULT NULL COMMENT '父级id',
  `page_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '页面路径',
  `sort_num` int(11) NULL DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (2, '数据报表', '/dashbord', 'el-icon-s-marketing', '11', 48, 'Dashbord', 11);
INSERT INTO `sys_menu` VALUES (4, '系统管理', NULL, 'el-icon-s-grid', NULL, NULL, NULL, 1);
INSERT INTO `sys_menu` VALUES (5, '用户管理', '/user', 'el-icon-user', NULL, 4, 'User', 2);
INSERT INTO `sys_menu` VALUES (6, '角色管理', '/role', 'el-icon-s-custom', NULL, 4, 'Role', 3);
INSERT INTO `sys_menu` VALUES (7, '菜单管理', '/menu', 'el-icon-menu', NULL, 4, 'Menu', 4);
INSERT INTO `sys_menu` VALUES (8, '在线模型训练', '/file', 'el-icon-document', NULL, 46, 'File', 7);
INSERT INTO `sys_menu` VALUES (10, '主页', '/home', 'el-icon-house', NULL, NULL, 'Home', 0);
INSERT INTO `sys_menu` VALUES (41, '采集日志', '/DataTest', 'el-icon-s-marketing', '在线测试模型数据', 48, 'DataTest', 9);
INSERT INTO `sys_menu` VALUES (45, '上传训练集', '/onlineupdate', 'el-icon-document', NULL, 46, 'onlineupdate', 6);
INSERT INTO `sys_menu` VALUES (46, '模型训练', NULL, 'el-icon-s-grid', NULL, NULL, NULL, 5);
INSERT INTO `sys_menu` VALUES (48, '高血压类型预测', '', 'el-icon-s-marketing', NULL, NULL, 'onlineDate', 12);
INSERT INTO `sys_menu` VALUES (49, '详细报表', '/Detilebord', 'el-icon-s-marketing', '11', 48, 'Detilebord', 13);
INSERT INTO `sys_menu` VALUES (50, '运维报修', NULL, 'el-icon-s-grid', NULL, NULL, NULL, 14);
INSERT INTO `sys_menu` VALUES (51, '故障报修', '/Send', 'el-icon-document', NULL, 50, 'Send', 15);
INSERT INTO `sys_menu` VALUES (52, '报修详情', '/List', 'el-icon-s-marketing', NULL, 50, 'List', 16);
INSERT INTO `sys_menu` VALUES (53, '在线预测', '/TestFile', 'el-icon-document', NULL, 48, 'TestFile', 10);
INSERT INTO `sys_menu` VALUES (54, '运维中心', NULL, 'el-icon-s-grid', NULL, NULL, NULL, 17);
INSERT INTO `sys_menu` VALUES (55, '运维详情', '/OMlist', 'el-icon-s-marketing', NULL, 54, 'OMlist', 18);
INSERT INTO `sys_menu` VALUES (56, '信息回执', '/OMsend', 'el-icon-document', NULL, 54, 'OMsend', 19);

-- ----------------------------
-- Table structure for sys_message
-- ----------------------------
DROP TABLE IF EXISTS `sys_message`;
CREATE TABLE `sys_message`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '故障类型',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '内容',
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `send_user_id` int(11) NULL DEFAULT NULL COMMENT '发送者用户ID',
  `send_user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送者用户名',
  `send_real_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发送者真实姓名',
  `receive_user_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '维修人员姓名',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_message_send_user_id`(`send_user_id`) USING BTREE,
  CONSTRAINT `FK_message_send_user_id` FOREIGN KEY (`send_user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_message
-- ----------------------------
INSERT INTO `sys_message` VALUES (6, '故障1', '故障0', '87848', '2023-08-02 12:29:34', 2, 'admin', 'admin', 'admin');
INSERT INTO `sys_message` VALUES (7, 'tsts', '故障0', 'ssssss', '2023-08-02 21:34:40', 2, 'admin', 'admin', 'admin');
INSERT INTO `sys_message` VALUES (8, '1', '故障0', '11hhhj', '2023-08-02 21:35:08', 2, 'admin', 'admin', 'test');
INSERT INTO `sys_message` VALUES (9, 'test1', '故障1', 'test1', '2023-08-05 13:50:46', 2, 'admin', 'admin', 'uphold');
INSERT INTO `sys_message` VALUES (10, 'test', '故障2', '11111111ss', '2023-08-07 20:26:07', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (11, 'test6', '故障2', '已查看，故障2修改完成。', '2023-08-08 12:54:23', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (12, 'test7', '故障5', '故障5，上报', '2023-08-15 13:24:33', 2, 'admin', 'admin', 'upload');
INSERT INTO `sys_message` VALUES (13, 'test6', '故障5', '故障5，上报', '2023-08-15 13:28:53', 2, 'admin', 'admin', 'upload');
INSERT INTO `sys_message` VALUES (14, 'test8', '故障5', '故障5，收到', '2023-08-15 13:32:33', 58, 'upload', 'upload', 'upload');
INSERT INTO `sys_message` VALUES (15, 'test10', '故障5', '11111111', '2023-08-17 09:51:11', 58, 'upload', 'upload', 'test');
INSERT INTO `sys_message` VALUES (16, 'test4', '故障3', '故障3，上报', '2023-08-17 15:20:44', 2, 'admin', 'admin', 'upload');
INSERT INTO `sys_message` VALUES (17, 'test5', '故障4', 'test5,111', '2023-08-17 19:16:28', 58, 'upload', 'upload', 'upload');
INSERT INTO `sys_message` VALUES (18, 'test12', '故障5', 'sssssssss', '2023-08-17 20:13:38', 58, 'upload', 'upload', 'upload');
INSERT INTO `sys_message` VALUES (19, 'test555', '故障2', 'ssadaxcxssssss', '2023-08-17 21:19:44', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (20, 'test', '故障2', 'sssssssss', '2023-08-17 21:59:04', 58, 'upload', 'upload', 'upload');
INSERT INTO `sys_message` VALUES (21, 'test1', '故障3', 'sssssssss', '2023-08-17 22:14:30', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (22, 'sss', '故障4', 'sssss,', '2023-08-17 22:59:46', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (23, 'tess1', '故障3', 'sssssss', '2023-08-17 23:20:25', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (24, 'sss', '故障4', '123456，，，', '2023-08-18 06:47:57', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (25, '事实上', '故障3', 'sss，sss', '2023-08-18 06:58:04', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (26, 'sssl', '故障1', 'ssss111，hhh', '2023-08-18 07:14:58', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (27, 'test22', '故障3', 'ssss,', '2023-08-18 09:10:51', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (28, 'test3', '故障3', '1111,ss', '2023-08-18 11:30:25', 58, 'upload', 'upload', 'admin');
INSERT INTO `sys_message` VALUES (29, '故障4', '故障4', 'test12231312', '2024-03-12 11:43:06', 58, 'upload', 'upload', 'admin');

-- ----------------------------
-- Table structure for sys_result
-- ----------------------------
DROP TABLE IF EXISTS `sys_result`;
CREATE TABLE `sys_result`  (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `testid` int(11) NOT NULL COMMENT '结果标签',
  `result` tinyint(1) NULL DEFAULT NULL COMMENT '预测结果',
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '生成时间',
  `testfile_id` int(10) NULL DEFAULT NULL COMMENT '测试集id，该表外键',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_result_testfile_id`(`testfile_id`) USING BTREE,
  CONSTRAINT `FK_result_testfile_id` FOREIGN KEY (`testfile_id`) REFERENCES `sys_testfile` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 109001 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `flag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '唯一标识',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '管理员', '管理员', 'ROLE_ADMIN');
INSERT INTO `sys_role` VALUES (2, '用户', '普通用户', 'ROLE_WORKER');
INSERT INTO `sys_role` VALUES (3, '运维', '运维', 'ROLE_MAINTENANCE');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` int(11) NOT NULL COMMENT '角色id',
  `menu_id` int(11) NOT NULL COMMENT '菜单id',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE,
  INDEX `menu_id`(`menu_id`) USING BTREE,
  CONSTRAINT `FK_role_menu_role_id` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `Fk_role_menu_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色菜单关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 2);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (3, 2);
INSERT INTO `sys_role_menu` VALUES (1, 4);
INSERT INTO `sys_role_menu` VALUES (1, 5);
INSERT INTO `sys_role_menu` VALUES (1, 6);
INSERT INTO `sys_role_menu` VALUES (1, 7);
INSERT INTO `sys_role_menu` VALUES (1, 8);
INSERT INTO `sys_role_menu` VALUES (2, 8);
INSERT INTO `sys_role_menu` VALUES (1, 10);
INSERT INTO `sys_role_menu` VALUES (2, 10);
INSERT INTO `sys_role_menu` VALUES (3, 10);
INSERT INTO `sys_role_menu` VALUES (1, 41);
INSERT INTO `sys_role_menu` VALUES (2, 41);
INSERT INTO `sys_role_menu` VALUES (3, 41);
INSERT INTO `sys_role_menu` VALUES (1, 45);
INSERT INTO `sys_role_menu` VALUES (2, 45);
INSERT INTO `sys_role_menu` VALUES (1, 46);
INSERT INTO `sys_role_menu` VALUES (2, 46);
INSERT INTO `sys_role_menu` VALUES (1, 48);
INSERT INTO `sys_role_menu` VALUES (2, 48);
INSERT INTO `sys_role_menu` VALUES (3, 48);
INSERT INTO `sys_role_menu` VALUES (1, 49);
INSERT INTO `sys_role_menu` VALUES (2, 49);
INSERT INTO `sys_role_menu` VALUES (3, 49);
INSERT INTO `sys_role_menu` VALUES (2, 50);
INSERT INTO `sys_role_menu` VALUES (2, 51);
INSERT INTO `sys_role_menu` VALUES (2, 52);
INSERT INTO `sys_role_menu` VALUES (1, 53);
INSERT INTO `sys_role_menu` VALUES (2, 53);
INSERT INTO `sys_role_menu` VALUES (3, 53);
INSERT INTO `sys_role_menu` VALUES (3, 54);
INSERT INTO `sys_role_menu` VALUES (3, 55);
INSERT INTO `sys_role_menu` VALUES (3, 56);

-- ----------------------------
-- Table structure for sys_testfile
-- ----------------------------
DROP TABLE IF EXISTS `sys_testfile`;
CREATE TABLE `sys_testfile`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件名称',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件类型',
  `size` bigint(20) NULL DEFAULT NULL COMMENT '文件大小(kb)',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '下载链接',
  `enable` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '是否预测',
  `md5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件md5',
  `is_delete` tinyint(1) NULL DEFAULT 0 COMMENT '是否删除',
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '生成时间',
  `user_id` int(10) NULL DEFAULT NULL COMMENT '用户id',
  `jsonUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'json文件地址',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_testfile_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `FK_testfile_user_id` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 273 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_testfile
-- ----------------------------
INSERT INTO `sys_testfile` VALUES (251, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/35dad1b95f684a0bbf9a037fac2e35af.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-17 18:10:13', 2, '7f3e41d7-9cb5-4dcf-b8fe-dc1a04520163.json');
INSERT INTO `sys_testfile` VALUES (252, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/4e6b10b5538744c0897a47cb56c2bfc6.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-17 18:47:57', 2, '54874678-f1e4-4143-af5d-430eaf5ef265.json');
INSERT INTO `sys_testfile` VALUES (259, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/20d3a13233f64c898e2067131c62f4b5.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-17 21:57:09', 2, '8b333b37-9983-4853-88c3-aaf9d7264a5c.json');
INSERT INTO `sys_testfile` VALUES (260, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/adabd98fd5794d6c9e932cf062804336.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-17 22:12:47', 2, '09b27261-b462-4cc5-9082-520784bc0e61.json');
INSERT INTO `sys_testfile` VALUES (261, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/de68a34299974e47a2f61993cceea970.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-17 22:57:57', 2, 'a1f1b93a-c10f-413a-ad4e-5032018178d7.json');
INSERT INTO `sys_testfile` VALUES (262, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/858ed8caf4a64f3eaa49bd92629c15ec.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-17 23:18:44', 2, 'f496f253-7451-4fdb-9d77-afca8a2a2d4d.json');
INSERT INTO `sys_testfile` VALUES (263, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/0c3002b3fedb45c8adf797e356b1223a.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-18 06:46:01', 2, 'c7f9d196-3b58-4d7a-b571-fdc3a97bb0f4.json');
INSERT INTO `sys_testfile` VALUES (264, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/e0ffe56b72874d31a0169b48f40cd081.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-18 06:56:02', 2, 'd589d794-1c20-407e-9484-f0af7b5fb03e.json');
INSERT INTO `sys_testfile` VALUES (265, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/2d0a21d60edc4b728649800156124ff0.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-18 07:12:58', 2, '96da2ba2-46cd-4b3c-b63c-872fc888e091.json');
INSERT INTO `sys_testfile` VALUES (266, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/0a85f4a6ac8b48e1ba5a0e8380cee23b.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-18 09:08:53', 2, 'd0729cd2-5b4a-4bec-90d7-e9fcb9c6e25c.json');
INSERT INTO `sys_testfile` VALUES (267, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/3442c19a9d3644cc9f8779053bdc5e4a.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-08-18 11:28:43', 2, '16b62841-80ba-4d18-b471-0d9f17e883fc.json');
INSERT INTO `sys_testfile` VALUES (269, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/48f23b7adc2342f9bfeb3a3352e05e37.csv', '1', '1a4d7411feca754cb401903ed9b24792', 0, '2023-12-15 10:03:30', 2, 'e6e2f750-7a83-4b5d-a802-1d02c6c9a351.json');
INSERT INTO `sys_testfile` VALUES (270, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/e2dd076da7a241ec8a045bc32cfdbf76.csv', '1', NULL, 0, '2024-01-23 09:13:36', 2, 'e2dd076da7a241ec8a045bc32cfdbf76.json');
INSERT INTO `sys_testfile` VALUES (271, 'test_2000_x.csv', 'csv', 3496, 'http://localhost:9090/DataTest/30c8d96cb7064aa59fe299d444de26e7.csv', '1', NULL, 0, '2024-03-12 11:41:11', 2, '30c8d96cb7064aa59fe299d444de26e7.json');
INSERT INTO `sys_testfile` VALUES (272, 'validate_1000.csv', 'csv', 1741, 'http://localhost:9090/DataTest/a03ec9b5b0d64d47a9630631979a89d0.csv', '1', NULL, 0, '2024-04-23 16:11:05', 2, 'a03ec9b5b0d64d47a9630631979a89d0.json');

-- ----------------------------
-- Table structure for sys_trainfile
-- ----------------------------
DROP TABLE IF EXISTS `sys_trainfile`;
CREATE TABLE `sys_trainfile`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件名称',
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件类型',
  `size` bigint(20) NULL DEFAULT NULL COMMENT '文件大小(kb)',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '下载链接',
  `pythonurl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `md5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件md5',
  `is_delete` tinyint(1) NULL DEFAULT 0 COMMENT '是否删除',
  `enable` tinyint(1) NULL DEFAULT 1 COMMENT '是否禁用链接',
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(10) NULL DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `FK_trainfile_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `FK_trainfile_user_id` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 239 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_trainfile
-- ----------------------------
INSERT INTO `sys_trainfile` VALUES (186, 'train_10000 - test.csv', 'csv', 16748, 'http://localhost:9090/python/0f7057866cdc4b36b49d8621e352dfad.csv', '0f7057866cdc4b36b49d8621e352dfad.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-07-13 15:31:14', 1);
INSERT INTO `sys_trainfile` VALUES (187, 'train_10000 - test.csv', 'csv', 16748, 'http://localhost:9090/python/440b848d28564d488072a1848b6d2fd3.csv', '440b848d28564d488072a1848b6d2fd3.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-07-14 09:55:04', 1);
INSERT INTO `sys_trainfile` VALUES (188, 'train_10000 - test.csv', 'csv', 16748, 'http://localhost:9090/python/52f8277d43e542e1a1fa83cc27ad7dc6.csv', '52f8277d43e542e1a1fa83cc27ad7dc6.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-07-14 10:59:35', 1);
INSERT INTO `sys_trainfile` VALUES (189, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/04038edc2ef94a0f93c48327285785d3.csv', '04038edc2ef94a0f93c48327285785d3.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-07-28 15:53:56', 1);
INSERT INTO `sys_trainfile` VALUES (190, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/89b60eeea2d3459f81b774e388d1d7f4.csv', '89b60eeea2d3459f81b774e388d1d7f4.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-07-31 16:21:11', 1);
INSERT INTO `sys_trainfile` VALUES (194, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/fe784f5612aa49c7aba5e87d3c2cb640.csv', 'fe784f5612aa49c7aba5e87d3c2cb640.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-07-31 16:50:09', 1);
INSERT INTO `sys_trainfile` VALUES (195, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/b8fdaaf9de844626889f34934372984c.csv', 'b8fdaaf9de844626889f34934372984c.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-07-31 16:51:37', 1);
INSERT INTO `sys_trainfile` VALUES (196, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/9df0c8f0ddad4184a4d2b6e656d6a3f4.csv', '9df0c8f0ddad4184a4d2b6e656d6a3f4.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-07-31 17:00:37', 1);
INSERT INTO `sys_trainfile` VALUES (197, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/22e5173c21b2407294330b4b041f8b66.csv', '22e5173c21b2407294330b4b041f8b66.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-07-31 17:05:52', 1);
INSERT INTO `sys_trainfile` VALUES (198, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/2fdc1a15caad42539ee1a4968a6698a0.csv', '2fdc1a15caad42539ee1a4968a6698a0.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-07-31 17:09:12', 1);
INSERT INTO `sys_trainfile` VALUES (200, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/eab854a5d2654fcda8ee7b4d28d29127.csv', 'eab854a5d2654fcda8ee7b4d28d29127.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-02 22:49:32', 1);
INSERT INTO `sys_trainfile` VALUES (201, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/388177f71a584c10bbc192add57e5de9.csv', '388177f71a584c10bbc192add57e5de9.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-03 15:01:10', 1);
INSERT INTO `sys_trainfile` VALUES (202, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/b79fd3c3fa3141df950e8dd40d965d20.csv', 'b79fd3c3fa3141df950e8dd40d965d20.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-04 20:27:40', 1);
INSERT INTO `sys_trainfile` VALUES (203, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/cca64c75703a4739a118a0ee6555f7a3.csv', 'cca64c75703a4739a118a0ee6555f7a3.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-04 20:35:19', 1);
INSERT INTO `sys_trainfile` VALUES (204, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/9db4fad9877b4d999dc60ddb9140f62e.csv', '9db4fad9877b4d999dc60ddb9140f62e.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-05 10:10:19', 1);
INSERT INTO `sys_trainfile` VALUES (205, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/421dba1e0a4b456bbec69d9d41594fdd.csv', '421dba1e0a4b456bbec69d9d41594fdd.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-05 10:11:27', 1);
INSERT INTO `sys_trainfile` VALUES (206, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/d3268348e1714a69a7f8d58ebb0095be.csv', 'd3268348e1714a69a7f8d58ebb0095be.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-05 10:12:54', 1);
INSERT INTO `sys_trainfile` VALUES (209, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/f1d062c5e7af4527a002c07deede2ea2.csv', 'f1d062c5e7af4527a002c07deede2ea2.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-15 13:01:00', 2);
INSERT INTO `sys_trainfile` VALUES (221, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/a599a92ec138490abfefbe4de8b58852.csv', 'a599a92ec138490abfefbe4de8b58852.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-17 21:55:49', 2);
INSERT INTO `sys_trainfile` VALUES (222, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/fb3abaddda444f04a5c1c2626e2799b3.csv', 'fb3abaddda444f04a5c1c2626e2799b3.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-17 22:11:33', 2);
INSERT INTO `sys_trainfile` VALUES (223, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/37de88d6fd4b420e99b5e19d8eedb6ea.csv', '37de88d6fd4b420e99b5e19d8eedb6ea.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-17 22:56:37', 2);
INSERT INTO `sys_trainfile` VALUES (224, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/76bf9b4485424a6c935e16476b0bf43b.csv', '76bf9b4485424a6c935e16476b0bf43b.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-17 23:17:26', 2);
INSERT INTO `sys_trainfile` VALUES (225, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/e361eb1f9d82454083b591d66b337c9f.csv', 'e361eb1f9d82454083b591d66b337c9f.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-18 06:44:48', 2);
INSERT INTO `sys_trainfile` VALUES (226, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/b04887621d864616aa8899917ee5eec5.csv', 'b04887621d864616aa8899917ee5eec5.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-18 06:54:54', 2);
INSERT INTO `sys_trainfile` VALUES (227, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/6fcfc9fc3a9b4e42b91f84a776fad9a5.csv', '6fcfc9fc3a9b4e42b91f84a776fad9a5.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-18 07:11:56', 2);
INSERT INTO `sys_trainfile` VALUES (228, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/3b8561cef3ed4a9fa6a8f4640dba252c.csv', '3b8561cef3ed4a9fa6a8f4640dba252c.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-18 09:07:51', 2);
INSERT INTO `sys_trainfile` VALUES (229, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/f2f09b68df2741ffb840b43a409ef2fa.csv', 'f2f09b68df2741ffb840b43a409ef2fa.h5', 'fa1cca2dc6de1942459a81acaa55e46c', 0, 1, '2023-08-18 11:27:27', 2);
INSERT INTO `sys_trainfile` VALUES (231, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/d78001b7b0a24fae94afbf0e782cbfb8.csv', 'd78001b7b0a24fae94afbf0e782cbfb8.h5', NULL, 0, 1, '2024-03-12 11:39:29', 2);
INSERT INTO `sys_trainfile` VALUES (232, 'validate_1000.csv', 'csv', 1741, 'http://localhost:9090/python/0851e9767bdb444aad232958e5298f11.csv', NULL, NULL, 0, 1, '2024-04-23 16:09:50', 2);
INSERT INTO `sys_trainfile` VALUES (233, 'validate_1000.csv', 'csv', 1741, 'http://localhost:9090/python/4f3890712e514dc8bb6a6adb503ffdc5.csv', NULL, NULL, 0, 1, '2024-04-23 16:10:51', 2);
INSERT INTO `sys_trainfile` VALUES (234, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/c9a726d945034c52b4f7fec81fcf2a15.csv', NULL, NULL, 0, 1, '2024-04-23 16:10:56', 2);
INSERT INTO `sys_trainfile` VALUES (235, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/81f534aca37b4ed992dc85d1b2eb9bd4.csv', NULL, NULL, 0, 1, '2024-04-23 16:11:21', 2);
INSERT INTO `sys_trainfile` VALUES (236, 'cb94533c128d47f6a18854728c4d2f47.csv', 'csv', 16748, 'http://localhost:9090/python/bda4ac0ded0e4f1fa0edb14f77824d90.csv', NULL, NULL, 0, 1, '2024-09-01 23:22:20', 2);
INSERT INTO `sys_trainfile` VALUES (237, 'c9a726d945034c52b4f7fec81fcf2a15.csv', 'csv', 16748, 'http://localhost:9090/python/f4de4baf44d747c9b6e3151e9b326aee.csv', NULL, NULL, 0, 1, '2024-09-01 23:22:34', 2);
INSERT INTO `sys_trainfile` VALUES (238, '4f3890712e514dc8bb6a6adb503ffdc5.csv', 'csv', 1741, 'http://localhost:9090/python/a384e50ac7514f5395fe688280b1313d.csv', NULL, NULL, 0, 1, '2024-09-02 13:38:12', 2);
INSERT INTO `sys_trainfile` VALUES (239, 'f4de4baf44d747c9b6e3151e9b326aee.csv', 'csv', 16748, 'http://localhost:9090/python/59a915b5edac419dbccff049bbdb15b3.csv', NULL, NULL, 0, 1, '2024-09-02 21:19:42', 2);
INSERT INTO `sys_trainfile` VALUES (240, 'train_10000.csv', 'csv', 16748, 'http://localhost:9090/python/e1cad81c698041a7be60634e65032dc9.csv', 'e1cad81c698041a7be60634e65032dc9.h5', NULL, 0, 1, '2024-09-03 00:16:08', 2);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `nickname` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `create_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
  `roleid` int(11) NOT NULL COMMENT 'roleId编号外键',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `Fk_user_role_id`(`roleid`) USING BTREE,
  INDEX `username`(`username`) USING BTREE,
  CONSTRAINT `Fk_user_role_id` FOREIGN KEY (`roleid`) REFERENCES `sys_role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'test', '202cb962ac59075b964b07152d234b70', 'test', 'test@qq.com', '12345678901', '南京', '2023-08-01 21:53:41', 'http://localhost:9090/file/Snipaste_2023-06-02_19-04-06.png', 'ROLE_WORKER', 2);
INSERT INTO `sys_user` VALUES (2, 'admin', '21232f297a57a5a743894a0e4a801fc3', 'admin', 'admin@.com', '12345678901', '南京', '2023-08-01 22:30:35', 'http://localhost:9090/file/q.png', 'ROLE_ADMIN', 1);
INSERT INTO `sys_user` VALUES (58, 'upload', '76ee3de97a1b8b903319b7c013d8c877', 'upload', 'upload@qq.com', '12345678901', '南京', '2023-08-06 15:48:40', 'http://localhost:9090/file/Snipaste_2023-06-02_19-04-06.png', 'ROLE_MAINTENANCE', 3);

SET FOREIGN_KEY_CHECKS = 1;
