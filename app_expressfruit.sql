-- phpMyAdmin SQL Dump
-- version 3.3.8.1
-- http://www.phpmyadmin.net
--
-- Host: w.rdc.sae.sina.com.cn:3307
-- Generation Time: May 06, 2016 at 09:47 AM
-- Server version: 5.6.23
-- PHP Version: 5.3.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `app_expressfruit`
--

-- --------------------------------------------------------

--
-- Table structure for table `contact_info`
--

DROP TABLE IF EXISTS `contact_info`;
CREATE TABLE IF NOT EXISTS `contact_info` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `f_id` int(10) unsigned NOT NULL,
  `name` text,
  `number` text,
  `address` text,
  `default_tag` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `Foreign key` (`f_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COMMENT='Users contact address and number.' AUTO_INCREMENT=7 ;

--
-- Dumping data for table `contact_info`
--

INSERT INTO `contact_info` (`id`, `f_id`, `name`, `number`, `address`, `default_tag`) VALUES
(1, 9, '早饭', '13482709087', '紫薇路25号', 1),
(2, 9, '明天', '15782416054', '川沙镇张江路38号', 0),
(3, 10, '测试', '13482785482', '测试', 1),
(4, 11, '测试', '13492898798', '玉兰香苑', 1),
(5, 16, '陈伟', '18701997665', '玉兰香苑', 1),
(6, 9, '测试', '58941505', '张江镇床边', 0);

-- --------------------------------------------------------

--
-- Table structure for table `fruit_desc`
--

DROP TABLE IF EXISTS `fruit_desc`;
CREATE TABLE IF NOT EXISTS `fruit_desc` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `f_id` int(3) NOT NULL DEFAULT '0',
  `number` int(3) NOT NULL,
  `desc` longtext,
  PRIMARY KEY (`id`),
  KEY `FK_fruit_desc_fruit_type` (`f_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=94 ;

--
-- Dumping data for table `fruit_desc`
--

INSERT INTO `fruit_desc` (`id`, `f_id`, `number`, `desc`) VALUES
(1, 1, 1, '包装图1'),
(2, 1, 2, '有爱的马里奥'),
(3, 2, 1, '个个饱满呐!'),
(4, 2, 2, '满满的两斤装~~'),
(5, 3, 1, '包装图'),
(6, 3, 2, '马里奥来咯~'),
(7, 1, 3, '来吃我吧!'),
(8, 2, 3, '十足的分量哦!'),
(9, 3, 3, '正面包装'),
(10, 4, 1, '果肉颗颗饱满'),
(11, 4, 2, '包装图1'),
(13, 5, 1, '诱人的黄车厘子,皮薄汁多'),
(14, 5, 2, '马里奥和车厘子'),
(16, 4, 3, '包装图2'),
(17, 6, 1, '亲,一整箱哦'),
(18, 6, 2, '皮薄汁多'),
(19, 6, 3, '每箱送专用勺哦~~'),
(20, 8, 1, '比比个'),
(21, 8, 2, '金黄诱人的果实!'),
(22, 8, 3, '每箱送专用勺哦~~'),
(23, 7, 1, '诱人的果实'),
(24, 7, 2, '个个都是精品哦~'),
(25, 7, 3, '每箱送专用勺哦~~'),
(26, 9, 1, '5斤装，送礼体面过人！'),
(27, 9, 2, '饱满又大个的诱人车厘子～'),
(28, 9, 3, '想吃我么？'),
(29, 10, 1, '原箱的哦！'),
(30, 10, 2, '鲜艳的苹果红色，看了就想吃掉它。'),
(31, 10, 3, '个个新鲜哦～'),
(32, 11, 1, '迷人的爱妃。'),
(33, 11, 2, '来自新西兰的爱妃苹果拥有顶级的口感和味道！'),
(37, 12, 1, '都乐出品，品质保证'),
(36, 11, 3, '颜色够鲜艳呐～～'),
(38, 12, 2, '小刀去皮，直接切片就可以吃喽，不需要“开槽”的菠萝！'),
(39, 12, 3, '都乐菠萝的甜度保证令你满意～'),
(40, 13, 1, '每个大小将近1斤左右'),
(41, 13, 2, '两个装'),
(42, 13, 3, '诱人的红～'),
(43, 16, 1, '牛油果吃的不是味道，而是营养！'),
(44, 16, 2, '切成块，拌沙拉还是很不错的。'),
(45, 16, 3, '切法：1.用小刀围着核环切。 2.用手一转一掰即可'),
(46, 17, 1, '2个装'),
(47, 17, 2, '营养及其丰富，但是味道清淡的牛油果可以拌色拉。'),
(48, 18, 1, '每天一杯柠檬水，富含维c又利于瘦身'),
(49, 18, 2, '进口柠檬不仅个头大，维c含量更是高'),
(50, 18, 3, '要不买一盒试试？和小伙伴分享呢～'),
(51, 19, 1, '泰国榴莲，不用说你也知道哈！'),
(52, 19, 2, '果实饱满，每一口都是满足！'),
(53, 19, 3, '可以要求剥好的哦！'),
(54, 20, 1, '澳洲脐橙，品质保证'),
(55, 20, 2, '鲜嫩多汁哦～'),
(56, 20, 3, '4个装'),
(57, 21, 1, '南非柚的口感有点小酸苦哦，去火必备'),
(58, 21, 2, '口感细腻滑爽～'),
(59, 21, 3, '诱人的颜色～'),
(60, 22, 1, '比白色的更甜哦！'),
(61, 22, 2, '切开来更诱人！'),
(62, 23, 1, '中秋礼盒，送礼体面过人！'),
(63, 23, 2, '［浓情进口礼盒］：台湾爱文芒果2个；进口柠檬4个；爱妃苹果3个；澳大利亚脐橙3个；新西兰奇异果4个'),
(64, 23, 3, '爱文芒果，超浓郁的芒果香气，扑鼻而来～'),
(65, 23, 4, '进口柠檬，含有丰富的维C'),
(66, 23, 5, '爱妃苹果，那口感！尝了才知道～'),
(67, 23, 6, '澳大利亚脐橙，又甜又多汁！'),
(68, 23, 7, '新西兰奇异果，老少皆宜！'),
(69, 24, 1, '原装进口哦！'),
(70, 24, 2, '而且是大个的哦！'),
(71, 24, 3, '顶级的口感，15个装值得分享！'),
(72, 25, 1, '完完整整的一箱哦！！'),
(73, 25, 2, '这么多才80哦？可以和家人朋友分享'),
(74, 25, 3, '个个都是精品哦～'),
(75, 26, 1, '1'),
(76, 26, 2, '2'),
(77, 26, 3, '3'),
(78, 26, 4, '4'),
(79, 26, 5, '5'),
(80, 26, 6, '6'),
(81, 26, 7, '7'),
(82, 26, 8, '8'),
(83, 26, 9, '9'),
(84, 26, 10, '10'),
(85, 27, 1, '1'),
(86, 27, 2, '2'),
(87, 27, 3, '3'),
(88, 27, 4, '4'),
(89, 27, 5, '5'),
(90, 27, 6, '6'),
(91, 27, 7, '7'),
(92, 27, 8, '8'),
(93, 27, 9, '9');

-- --------------------------------------------------------

--
-- Table structure for table `fruit_type`
--

DROP TABLE IF EXISTS `fruit_type`;
CREATE TABLE IF NOT EXISTS `fruit_type` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `f_type` text NOT NULL,
  `unit_price` int(3) NOT NULL DEFAULT '0',
  `unit` text NOT NULL,
  `enable` int(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=235 ;

--
-- Dumping data for table `fruit_type`
--

INSERT INTO `fruit_type` (`id`, `f_type`, `unit_price`, `unit`, `enable`) VALUES
(1, '车厘子', 48, '盒(1斤装)', 0),
(2, '车厘子', 95, '盒(2斤装)', 0),
(3, '美国啤梨', 50, '盒(6个)', 0),
(4, '泰国山竹', 25, '盒(2斤装)', 0),
(5, '黄车厘子(蕾妮儿)', 75, '盒(1斤装)', 0),
(6, '新西兰佳沛绿色奇异果', 145, '原箱', 1),
(7, '新西兰佳沛金色奇异果', 195, '原箱', 1),
(8, '新西兰佳沛金色奇异果(超大)', 210, '原箱(27个)', 1),
(9, '车厘子', 220, '箱(5斤装)', 0),
(15, '新西兰佳沛金色奇异果(巨大)', 250, '原箱(22个)', 0),
(10, '台湾爱文芒果', 250, '原箱(10-12个装)', 1),
(11, '新西兰爱妃(小)苹果', 58, '盒(4个装)', 1),
(12, '都乐菠萝', 28, '个', 1),
(13, '台湾爱文芒果', 55, '盒(2个装)', 1),
(14, '台湾爱文芒果', 160, '盒(6个装)', 0),
(16, '墨西哥牛油果', 46, '盒(4个装)', 1),
(17, '墨西哥牛油果', 24, '盒(2个装)', 0),
(18, '进口柠檬', 38, '盒(8个装)', 1),
(19, '泰国榴莲', 80, '个(7-9斤)', 1),
(20, '澳洲脐橙', 25, '盒(4个装)', 0),
(21, '南非葡萄柚', 28, '盒(4个装)', 1),
(22, '红心火龙果', 15, '个', 1),
(23, '中秋礼盒', 188, '盒', 0),
(26, '礼盒A', 228, '盒', 1),
(24, '新西兰爱妃(大)苹果', 250, '原箱(15个)', 1),
(25, '云南蒙自石榴', 80, '箱(22个)', 1),
(27, '礼盒B', 258, '盒', 1);

-- --------------------------------------------------------

--
-- Table structure for table `fruit_type_test`
--

DROP TABLE IF EXISTS `fruit_type_test`;
CREATE TABLE IF NOT EXISTS `fruit_type_test` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `f_type` text NOT NULL,
  `unit_price` int(3) NOT NULL DEFAULT '0',
  `unit` text NOT NULL,
  `enable` int(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=26 ;

--
-- Dumping data for table `fruit_type_test`
--

INSERT INTO `fruit_type_test` (`id`, `f_type`, `unit_price`, `unit`, `enable`) VALUES
(1, '车厘子', 48, '盒(1斤装)', 0),
(2, '车厘子', 95, '盒(2斤装)', 0),
(3, '美国啤梨', 50, '盒(6个)', 0),
(4, '泰国山竹', 25, '盒(2斤装)', 0),
(5, '黄车厘子(蕾妮儿)', 75, '盒(1斤装)', 0),
(6, '佳沛绿奇异果', 145, '原箱', 1),
(7, '佳沛金奇异果', 195, '原箱', 1),
(8, '佳沛金奇异果(大)', 210, '原箱', 1),
(9, '车厘子', 220, '5斤', 1),
(15, '新西兰佳沛金色奇异果(巨大)', 250, '原箱(22个)', 0),
(10, '台湾爱文芒果', 250, '原箱', 1),
(11, '爱妃(小)苹果', 60, '4个', 1),
(12, '都乐菠萝', 28, '1个', 1),
(13, '台湾爱文芒果', 55, '2个', 1),
(14, '台湾爱文芒果', 160, '盒(6个装)', 0),
(16, '墨西哥牛油果', 38, '4个', 1),
(17, '墨西哥牛油果', 24, '盒(2个装)', 0),
(18, '进口柠檬', 38, '8个', 1),
(19, '泰国榴莲', 80, '个(6-8斤)', 1),
(20, '澳洲脐橙', 25, '盒(4个装)', 0),
(21, '南非葡萄柚', 28, '4个', 1),
(22, '红心火龙果', 15, '1个', 1),
(23, '中秋礼盒', 188, '盒', 1),
(24, '爱妃(大)苹果', 250, '原箱', 1),
(25, '云南蒙自石榴', 80, '原箱', 1);

-- --------------------------------------------------------

--
-- Table structure for table `gift_fruit`
--

DROP TABLE IF EXISTS `gift_fruit`;
CREATE TABLE IF NOT EXISTS `gift_fruit` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `gift_fruit_type` text,
  `gift_fruit_unit` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `gift_fruit`
--

INSERT INTO `gift_fruit` (`id`, `gift_fruit_type`, `gift_fruit_unit`) VALUES
(1, 'Sunkist柠檬', '1个'),
(2, 'Sunkist柠檬', '2个'),
(3, '澳大利亚脐橙', '1个'),
(4, '澳大利亚脐橙', '2个'),
(5, '新西兰红玫瑰苹果', '1个'),
(6, '新西兰红玫瑰苹果', '2个'),
(7, '墨西哥牛油果', '1个'),
(8, '佳沛奇异果', '1个'),
(9, '佳沛金奇异果', '1个'),
(10, '美国车厘子', '1盒');

-- --------------------------------------------------------

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE IF NOT EXISTS `order_detail` (
  `order_id` int(10) unsigned NOT NULL,
  `fruit_1` text,
  `unit_1` text,
  `unit_price_1` int(3) DEFAULT NULL,
  `quantity_1` int(3) DEFAULT NULL,
  `fruit_2` text,
  `unit_2` text,
  `unit_price_2` int(3) DEFAULT NULL,
  `quantity_2` int(3) DEFAULT NULL,
  `fruit_3` text,
  `unit_3` text,
  `unit_price_3` int(3) DEFAULT NULL,
  `quantity_3` int(3) DEFAULT NULL,
  `fruit_4` text,
  `unit_4` text,
  `unit_price_4` int(3) DEFAULT NULL,
  `quantity_4` int(3) DEFAULT NULL,
  `fruit_5` text,
  `unit_5` text,
  `unit_price_5` int(3) DEFAULT NULL,
  `quantity_5` int(3) DEFAULT NULL,
  `fruit_6` text,
  `unit_6` text,
  `unit_price_6` int(3) DEFAULT NULL,
  `quantity_6` int(3) DEFAULT NULL,
  `fruit_7` text,
  `unit_7` text,
  `unit_price_7` int(3) DEFAULT NULL,
  `quantity_7` int(3) DEFAULT NULL,
  `fruit_8` text,
  `unit_8` text,
  `unit_price_8` int(3) DEFAULT NULL,
  `quantity_8` int(3) DEFAULT NULL,
  `fruit_9` text,
  `unit_9` text,
  `unit_price_9` int(3) DEFAULT NULL,
  `quantity_9` int(3) DEFAULT NULL,
  `fruit_10` text,
  `unit_10` text,
  `unit_price_10` int(3) DEFAULT NULL,
  `quantity_10` int(3) DEFAULT NULL,
  `gift_type` int(11) DEFAULT NULL,
  `gift_content` text,
  `total_price` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `order_detail`
--

INSERT INTO `order_detail` (`order_id`, `fruit_1`, `unit_1`, `unit_price_1`, `quantity_1`, `fruit_2`, `unit_2`, `unit_price_2`, `quantity_2`, `fruit_3`, `unit_3`, `unit_price_3`, `quantity_3`, `fruit_4`, `unit_4`, `unit_price_4`, `quantity_4`, `fruit_5`, `unit_5`, `unit_price_5`, `quantity_5`, `fruit_6`, `unit_6`, `unit_price_6`, `quantity_6`, `fruit_7`, `unit_7`, `unit_price_7`, `quantity_7`, `fruit_8`, `unit_8`, `unit_price_8`, `quantity_8`, `fruit_9`, `unit_9`, `unit_price_9`, `quantity_9`, `fruit_10`, `unit_10`, `unit_price_10`, `quantity_10`, `gift_type`, `gift_content`, `total_price`) VALUES
(1, '车厘子', '盒(1斤装)', 48, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 96),
(2, '车厘子', '盒(2斤装)', 95, 1, '美国啤梨', '盒(6个)', 50, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 145),
(4, '车厘子', '盒(2斤装)', 95, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 190),
(5, '新西兰佳沛绿色奇异果', '原箱', 135, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 270),
(6, '车厘子', '盒(1斤装)', 48, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 96),
(7, '新西兰佳沛金色奇异果(超大)', '原箱', 210, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 210),
(8, '新西兰佳沛金色奇异果', '原箱', 185, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 185),
(9, '泰国山竹', '盒(2斤装)', 25, 1, '车厘子', '盒(2斤装)', 95, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 120),
(10, '车厘子', '盒(1斤装)', 48, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 48),
(11, '车厘子', '盒(2斤装)', 95, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 190),
(12, '新西兰佳沛金色奇异果(超大)', '原箱', 210, 2, '泰国山竹', '盒(2斤装)', 25, 9, '车厘子', '盒(2斤装)', 95, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1595),
(13, '新西兰佳沛金色奇异果(超大)', '原箱(27个)', 210, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 420),
(14, '新西兰佳沛绿色奇异果', '原箱', 145, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 145);

-- --------------------------------------------------------

--
-- Table structure for table `order_info`
--

DROP TABLE IF EXISTS `order_info`;
CREATE TABLE IF NOT EXISTS `order_info` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `f_id` int(10) unsigned NOT NULL,
  `order_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `receiver` text NOT NULL,
  `contact_number` char(11) NOT NULL,
  `address` text NOT NULL,
  `order_status` int(2) NOT NULL DEFAULT '1',
  `sender` text,
  `express_fee` int(3) DEFAULT NULL,
  `comment` longtext,
  PRIMARY KEY (`id`),
  KEY `FK_order_info_user_info` (`f_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=15 ;

--
-- Dumping data for table `order_info`
--

INSERT INTO `order_info` (`id`, `f_id`, `order_time`, `receiver`, `contact_number`, `address`, `order_status`, `sender`, `express_fee`, `comment`) VALUES
(1, 9, '2014-07-17 13:53:02', '早饭', '13482709087', '川沙镇紫薇路25号', 6, NULL, 0, '你好啊'),
(2, 9, '2014-07-17 13:53:56', '明天', '15782416054', '川沙镇张江路38号', 6, NULL, 0, ''),
(4, 9, '2014-07-21 11:14:17', '明天', '15782416054', '川沙镇张江路38号', 6, NULL, 0, ''),
(5, 9, '2014-07-21 14:56:52', '早饭', '13482709087', '紫薇路25号', 3, NULL, 0, ''),
(6, 10, '2014-07-26 21:17:39', '测试', '13482785482', '川沙镇测试', 6, NULL, 0, ''),
(7, 9, '2014-07-27 18:17:32', '明天', '15782416054', '川沙镇张江路38号', 6, NULL, 0, ''),
(8, 9, '2014-07-27 18:51:32', '明天', '15782416054', '川沙镇张江路38号', 6, NULL, 0, ''),
(9, 16, '2014-07-27 19:44:26', '陈伟', '18701997665', '张江镇玉兰香苑', 3, NULL, 0, ''),
(10, 9, '2014-07-28 18:08:50', '早饭', '13482709087', '紫薇路25号', 6, NULL, 0, ''),
(11, 9, '2014-08-08 13:25:14', '明天', '15782416054', '川沙镇张江路38号', 6, NULL, 0, ''),
(12, 9, '2014-08-11 19:45:42', '测试', '58941505', '张江镇床边', 3, NULL, 0, ''),
(13, 10, '2014-08-22 19:21:49', '测试', '13482785482', '测试', 6, NULL, 0, ''),
(14, 9, '2014-09-01 12:03:21', '早饭', '13482709087', '紫薇路25号', 6, NULL, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `promotion_code`
--

DROP TABLE IF EXISTS `promotion_code`;
CREATE TABLE IF NOT EXISTS `promotion_code` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `code` tinytext,
  `hashcode` tinytext,
  `gift_id` int(1) DEFAULT NULL,
  `valid` int(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=81 ;

--
-- Dumping data for table `promotion_code`
--

INSERT INTO `promotion_code` (`id`, `code`, `hashcode`, `gift_id`, `valid`) VALUES
(1, '3788513787', '6cfe1266b35d368a2a81b3c7f09e7844b57c5f97', 1, 1),
(2, '2878013536', '7e0a8f5b28789e7dfb88836429a280d2398f3367', 1, 1),
(3, '2464514017', '8b58200031d724753e9fc379ba927eb9ae002216', 1, 1),
(4, '9615112027', '92c042dabe316f8ee9f9453b5918ba556bf68f9b', 3, 1),
(5, '7894014703', 'c93a2683dcd7cd0f74022c13c3289c96cdfcc121', 3, 1),
(6, '3892218122', '37e7fa08e4088524e010851b3527e3362abdd70c', 5, 1),
(7, '6664113044', '6dcef7ef14c60e5bc273a26f463aae836df1ca49', 5, 1),
(8, '3426517090', '9528b8e8612020bb595a7ce03bba55656e1a8c12', 11, 1),
(9, '2248812362', '75459098fbe47d850ec5ded82b2600c8070a6f7c', 11, 1),
(10, '7690411703', 'c0db891e7a6b35c504db0717137e29e9dbe819c4', 2, 1),
(11, '8448314055', '30bd6bba98a8af012658300a4b4993ac4f9159c8', 1, 1),
(12, '8954318972', '09dc395ab1889e8a1559c6b8e1ae2ab491503784', 1, 1),
(13, '4372115369', '7230be47596ab9e569cee4bfa6bcf82b76238a85', 1, 1),
(14, '9355315282', '53e74ebc9ea6586ce27794b914c2119ddcfccc49', 3, 1),
(15, '8517011628', 'c076cd9dfbdca2043b99dc0e1622eff8c4260ee0', 3, 1),
(16, '5091217948', '48abd637aedfdea799797342db99e35a03844008', 5, 1),
(17, '8360915715', '8e2cedd5efb7a3eaae0f9709ae28a0f67dd6095c', 5, 1),
(18, '2544616992', 'beb49e2991d79ddec6e0e32da33edd95e443ec45', 11, 1),
(19, '9366411186', '459461fb641d19b50f0de21602b69a9a291cb5c4', 11, 1),
(20, '3583712182', '42660407f6e9c2c01c500029d6aa12087c448039', 2, 1),
(21, '9415712645', '93a96a18d6c12a3c5cf2d4f6f990c89297186998', 1, 1),
(22, '6498916728', '4981a73a11ad673e97d1438348d6b985adc9bbe7', 1, 1),
(23, '1690813539', '3dca914d637e33674aa78fc76994c96977eac56d', 1, 1),
(24, '2327017147', 'd5841fda0948dcd297aa06ed413ddbdeee2ebfc7', 3, 1),
(25, '5575915624', '3efa1d6539cb614cdf11aa051c8631e777272a5b', 3, 1),
(26, '1721815457', '08d3f069a4be5e5f82a5cddf183f5b546bf59d3f', 5, 1),
(27, '3617812061', '66a60f9ac0b1bbbe619fbdba64eadf3492c38eaa', 5, 1),
(28, '1483714743', '8cbf502e992da4ee8dcc8237177896ac825db6ea', 11, 1),
(29, '3881017358', 'f49c8d1bf156efce32da77eeb55df52c5f3cdd2f', 11, 1),
(30, '9788111316', '30c27e6d4a3d96b4ce4607a3bdea18513f3f9103', 4, 1),
(31, '3783017045', '7f105683efce698203e6d230de12f1cde18db3b9', 1, 1),
(32, '3820918194', 'd9cc7523c528fccd58cb223ec49762d5d785131a', 1, 1),
(33, '1621315995', 'a76f8245f0e4b9f09939889679f6ed06df4e506e', 1, 1),
(34, '8191711014', '26e4fb36b580bfe088c78d9b51f85f18857f5a4d', 3, 1),
(35, '4808114068', 'adb9ace1d60d6b4308e0c8e0f224a29c716637ed', 3, 1),
(36, '2495712587', '0b7d61b1707a56536e3fd365272834b6c8e4de13', 5, 1),
(37, '6485617798', 'a3f53f21f354d8c8a70286dc093dbaa6ced2e51c', 5, 1),
(38, '5927012192', 'cc4c0b5dfc51e6d9f1fcfb4e0c06410284373f65', 11, 1),
(39, '5300913237', 'c0fec5f44adf325c6af6b3ec9b3a7440ed26066e', 11, 1),
(40, '2653012421', '62707232380648b22669e7bcc942def12508ade3', 6, 1),
(41, '7932911008', 'f142455ecb23837e251ea17687112b1b4b68de7b', 1, 1),
(42, '1293210037', '1d75c526dac518d6b807064a9bfe09c1d5ddd416', 1, 1),
(43, '7344814386', '64a35f3667899a86d6c4fcbc0fea41ea24cfef66', 1, 1),
(44, '9574917663', '69bc9b32ddce062b67df54473c53e3fff8d9ceee', 3, 1),
(45, '2450414179', 'da3ff46b8498a7140d41cf53682481b1282738dd', 3, 1),
(46, '6189815039', '929606f8a432648012548661a91623b0d56ed983', 5, 1),
(47, '7042615171', 'f619ae166b5bc53fb15704c128d1c584b98e567e', 5, 1),
(48, '3922415360', 'af791013a6f6683f18d99d0a7db72ed6ece46562', 11, 1),
(49, '9760616848', '018195ff6b2dc39423b56a01eb481fb39f91bdce', 11, 1),
(50, '8866612857', '007abf27839698ba1468cf50b22a817fcffc6a58', 4, 1),
(51, '1926114621', 'f2f5bec41bc00c48180ba12d4fbab4b30135f79b', 1, 1),
(52, '7397012961', '0bf0ba7f4ac22c59fe81272b31658c3a1376bfbd', 1, 1),
(53, '5165717147', '42afb9c412485aa72b6215c464656d21dab36bc3', 1, 1),
(54, '2251417586', '062af0da9fbb5d59d4c6222977d2e4ddd573c812', 3, 1),
(55, '3644110282', '00951a8e367c66c147be09f833397bc412fc18fa', 3, 1),
(56, '4173617900', '44a468602f801a4794130f4a50d6a2e9e7f6545d', 5, 1),
(57, '6762014186', '1cf6e3c2509ad6a79cf5a42a2eb4fba866c192e3', 5, 1),
(58, '2753310011', 'adb0a90d14720153ba701c65afd2c8a18d3002b6', 11, 1),
(59, '2698913445', '01ab1be3f6ed76e37e7e9a6060f392e0bfa78347', 11, 1),
(60, '1350515477', '0f82435afceedb6b26f77dd4e139e051a0a973c9', 4, 1),
(61, '6707110857', 'b6c8ac7f4b4443117f5821482e915fb3fc9e9b21', 1, 1),
(62, '1710013429', 'f2230c904aab8586329735d902402f17689839dd', 1, 1),
(63, '1220818172', '101e8498111507e6386ae871670cc60fd651d564', 1, 1),
(64, '1851118445', '3404e91f32f14dd53ae83b5dd520c1db4ab32dd8', 3, 1),
(65, '7575317691', '0e13c61b2ba6ec482b0ebdf0b3db3dcf1a7eae18', 3, 1),
(66, '3671915766', '85791b981b1469ceabd29cdfd2758e9dee790388', 5, 1),
(67, '7602511184', '4187cf62a025a83f5f7e24cdf56f3c040a135b95', 5, 1),
(68, '3695613405', '732a8d640e66c640cbac5e23ca935f948e291455', 11, 1),
(69, '2822918089', '8a5baf0e772230d8ea087d03785f45de78d54a3c', 11, 1),
(70, '7488914254', 'd34553320a33148b72541ba1ef91957d08f3b7c3', 2, 1),
(71, '2585118054', '31ed0455ad0b5143f693e22e14c94f0f2b10543d', 1, 1),
(72, '3593218217', 'dafe9b821562a3106758bb521f334cf8421279e8', 1, 1),
(73, '3755716280', 'd5b5a195512608a9f7c2193983960925f3d08507', 1, 1),
(74, '1075015486', '59a5d2145cc330270aa9ad138b11f76ba72ef77f', 3, 1),
(75, '9802815215', '34b8c3d9562bc230d7fc87b64b6a47313560327b', 3, 1),
(76, '7517715210', '1a55e99893d784b79bfe3b2a5066f2bae512e0d4', 5, 1),
(77, '9103211355', 'b13b26df182262de65eb351b8ab86932b900980c', 5, 1),
(78, '8345313394', '4d2f77a9744944054d5d2d4d57513f674a60a58e', 11, 1),
(79, '9257918962', '0d8905f98f91937be959d5aa1a178382b584e794', 11, 1),
(80, '2044213527', 'bafb5b72408d2cb648c782d95b162cca40c8763d', 12, 1);

-- --------------------------------------------------------

--
-- Table structure for table `promotion_gift`
--

DROP TABLE IF EXISTS `promotion_gift`;
CREATE TABLE IF NOT EXISTS `promotion_gift` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `type` int(10) DEFAULT NULL,
  `1_fruit_type` int(11) DEFAULT NULL,
  `2_coupon` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `promotion_gift`
--

INSERT INTO `promotion_gift` (`id`, `type`, `1_fruit_type`, `2_coupon`) VALUES
(1, 1, 1, NULL),
(2, 1, 2, NULL),
(3, 1, 3, NULL),
(4, 1, 4, NULL),
(5, 1, 5, NULL),
(6, 1, 6, NULL),
(7, 1, 7, NULL),
(8, 1, 8, NULL),
(9, 1, 9, NULL),
(10, 1, 10, NULL),
(11, 2, NULL, 5),
(12, 2, NULL, 10),
(13, 2, NULL, 15);

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

DROP TABLE IF EXISTS `user_info`;
CREATE TABLE IF NOT EXISTS `user_info` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `open_id` text,
  `user_id` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=32 ;

--
-- Dumping data for table `user_info`
--

INSERT INTO `user_info` (`id`, `open_id`, `user_id`) VALUES
(9, 'o73-otylwVo7mSAwOoLAvtmFuiaA', '5078ec17bb7aff78c7237d1c66e9b7441c2b4348'),
(10, 'o73-otzFmI67jfMxCa2gaHDU35P4', '9eac00adb7c8ab33c9ef7b252174cd46652583bd'),
(11, 'o73-otw3fyXj3ktUwkdsKo13sQjI', '5188a4d21f351fae3362fa5559a6ccce585297ac'),
(12, 'o73-ot6_j1iWEM0B8EWc1nyjFP_I', '39f838cda3c8380a8880fe419b59644f4f3e57dc'),
(15, 'o73-ot412C9fPzMAgCyh6IACLO10', '33d8c7ebd60140b3a80d56dd630724e82a079355'),
(14, 'o73-ot-q4CqND-86focyHfqX5qMY', 'd0fa0681a5a7234bf476961ca1067b100d5e9694'),
(16, 'o73-ot2EYO6DSa4krwON1sIfObnA', 'c194c724e0d97a3ff818277c5dd3a118adcfd668'),
(17, 'o73-ot07O_sUQWiGNzvgrQwm_DTk', 'd3839d7c8fe5af924e993a7733f1a36ce629bad8'),
(18, 'o73-ot0a7HEMa8FMjIaj4Us6zo-8', '63e6d90f13698eb6056664685a8a57d72d9db5f2'),
(19, 'o73-otwERLmOgQGsflCN1HUroGn0', '303f15e2e1716367d2d4469d74525b9f37fefc1a'),
(20, 'o73-ot44kbK4jLGLgRtxG13nUfh0', 'ca03f32434fdddbe664683d2914f7612eabd8979'),
(21, 'o73-ot9q2fGRrklA7JhEnf4YldXM', '65ee8d8e1498adfed26dbeea81a88866ddf21eb9'),
(22, 'o73-otz_Rp_GLa4jJvD-Z0fHzXfo', 'd690930fbae69d8ce26c3d167b7597702b773411'),
(23, 'o73-ot4FWxOeBtz54qayioU4pWwo', '780b3bbbc083207db9efbfb17ca84aba4dd5dd69'),
(24, 'o73-ot4sAWyB7e_j90oSYIl0_ah4', 'b88cc15bfafd2660b3e86019c69703025fbb1be1'),
(25, 'o73-ot0PZBdDAiEvT_YM4S7BhveI', '7ea143f521465928217b33b4ab3b3e71d849f90b'),
(26, 'o73-ot2LMPaNazy7AMjfWzSbbAWU', '8374d673d667fbe65a485e2b3b2b0752295274f4'),
(27, 'o73-ot_SkkMI266cKQ22aGDcPwK4', 'ba63f7501d7374c5eb809ae5d83ca43cf2dc1a66'),
(28, 'o73-ot9Er-mVYU3EMja3IkQsE9nk', '8eb02887585dbf0be9f9b8a917c5f1d3a7fbc243'),
(29, 'o73-ot1vpWaFHp-EJYLhTsm0tgQQ', '8be3ac6ab4bf95a8fe3bbd9a517301fbc00f37cc'),
(30, '123', 'd23b9ca2037dfd08a79db1f97e47dccb6ba3be4e'),
(31, 'o73-otyPBYQ9RYEejQjRIKuHiLQ4', '3c09e8413c480a448fcc857579c5c3bc0769ccb0');
