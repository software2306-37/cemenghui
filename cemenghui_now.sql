--
-- Kingbase database dump
--

-- Dumped from database version 12.1
-- Dumped by sys_dump version 12.1

-- Started on 2025-07-05 16:21:59

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'GBK';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', 'public', false);
SET exclude_reserved_words = '';
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 27 (class 2615 OID 16652)
-- Name: cemenghui_now; Type: SCHEMA; Schema: -; Owner: system
--

CREATE SCHEMA cemenghui_now;


ALTER SCHEMA cemenghui_now OWNER TO system;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 610 (class 1259 OID 16775)
-- Name: banner; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.banner (
    id bigint NOT NULL,
    title character varying(200 char) NOT NULL,
    image_url character varying(255 char) NOT NULL,
    link_url character varying(255 char),
    sort_order integer DEFAULT 0,
    status tinyint DEFAULT 1 NOT NULL,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.banner OWNER TO system;

--
-- TOC entry 9724 (class 0 OID 0)
-- Dependencies: 610
-- Name: TABLE banner; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.banner IS '轮播图表';


--
-- TOC entry 9725 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.id IS '轮播图ID';


--
-- TOC entry 9726 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.title; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.title IS '标题';


--
-- TOC entry 9727 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.image_url; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.image_url IS '图片URL';


--
-- TOC entry 9728 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.link_url; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.link_url IS '链接URL';


--
-- TOC entry 9729 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.sort_order; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.sort_order IS '排序';


--
-- TOC entry 9730 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.status IS '状态 0-禁用 1-启用';


--
-- TOC entry 9731 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.create_time IS '创建时间';


--
-- TOC entry 9732 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.update_time IS '更新时间';


--
-- TOC entry 596 (class 1259 OID 16687)
-- Name: course; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.course (
    id bigint NOT NULL,
    course_name character varying(200 char) NOT NULL,
    course_summary text,
    cover_image character varying(255 char),
    video_url character varying(255 char),
    author character varying(50 char) NOT NULL,
    author_id bigint NOT NULL,
    sort_order integer DEFAULT 0,
    status tinyint DEFAULT 0 NOT NULL,
    audit_time datetime,
    audit_user_id bigint,
    view_count integer DEFAULT 0,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.course OWNER TO system;

--
-- TOC entry 9733 (class 0 OID 0)
-- Dependencies: 596
-- Name: TABLE course; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.course IS '课程表';


--
-- TOC entry 9734 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.id IS '课程ID';


--
-- TOC entry 9735 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.course_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.course_name IS '课程名称';


--
-- TOC entry 9736 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.course_summary; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.course_summary IS '课程简介';


--
-- TOC entry 9737 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.cover_image; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.cover_image IS '课程封面';


--
-- TOC entry 9738 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.video_url; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.video_url IS '课程视频';


--
-- TOC entry 9739 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.author; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.author IS '作者';


--
-- TOC entry 9740 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.author_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.author_id IS '作者ID';


--
-- TOC entry 9741 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.sort_order; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.sort_order IS '排序';


--
-- TOC entry 9742 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.status IS '状态 0-待审核 1-已发布 2-已拒绝';


--
-- TOC entry 9743 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.audit_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.audit_time IS '审核时间';


--
-- TOC entry 9744 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.audit_user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.audit_user_id IS '审核人ID';


--
-- TOC entry 9745 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.view_count; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.view_count IS '浏览次数';


--
-- TOC entry 9746 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.create_time IS '创建时间';


--
-- TOC entry 9747 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.update_time IS '更新时间';


--
-- TOC entry 592 (class 1259 OID 16661)
-- Name: course_enrollment; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.course_enrollment (
    id bigint NOT NULL,
    course_id bigint NOT NULL,
    user_id bigint NOT NULL,
    user_name character varying(50 char),
    user_email character varying(100 char),
    user_phone character varying(20 char),
    progress integer DEFAULT 0,
    status integer DEFAULT 0,
    enrollment_time datetime,
    start_time datetime,
    complete_time datetime,
    create_time datetime DEFAULT CURRENT_TIMESTAMP,
    update_time datetime DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE cemenghui_now.course_enrollment OWNER TO system;

--
-- TOC entry 9748 (class 0 OID 0)
-- Dependencies: 592
-- Name: TABLE course_enrollment; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.course_enrollment IS '课程报名/学习记录表';


--
-- TOC entry 9749 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.id IS 'ID';


--
-- TOC entry 9750 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.course_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.course_id IS '课程ID';


--
-- TOC entry 9751 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.user_id IS '用户ID';


--
-- TOC entry 9752 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.user_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.user_name IS '用户姓名';


--
-- TOC entry 9753 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.user_email; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.user_email IS '用户邮箱';


--
-- TOC entry 9754 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.user_phone; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.user_phone IS '用户电话';


--
-- TOC entry 9755 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.progress; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.progress IS '学习进度 0-100';


--
-- TOC entry 9756 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.status IS '状态 0:已报名 1:学习中 2:已完成 3:已取消';


--
-- TOC entry 9757 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.enrollment_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.enrollment_time IS '报名时间';


--
-- TOC entry 9758 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.start_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.start_time IS '开始学习时间';


--
-- TOC entry 9759 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.complete_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.complete_time IS '完成时间';


--
-- TOC entry 9760 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.create_time IS '创建时间';


--
-- TOC entry 9761 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.update_time IS '更新时间';


--
-- TOC entry 612 (class 1259 OID 16788)
-- Name: course_video; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.course_video (
    id bigint NOT NULL,
    course_id bigint NOT NULL,
    video_title character varying(200 char) NOT NULL,
    video_url character varying(500 char) NOT NULL,
    video_duration integer DEFAULT 0,
    video_size bigint DEFAULT 0,
    video_description text,
    sort_order integer DEFAULT 0,
    is_free tinyint DEFAULT 0,
    status tinyint DEFAULT 1,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.course_video OWNER TO system;

--
-- TOC entry 9762 (class 0 OID 0)
-- Dependencies: 612
-- Name: TABLE course_video; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.course_video IS '课程视频表';


--
-- TOC entry 9763 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.id IS '视频ID';


--
-- TOC entry 9764 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.course_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.course_id IS '课程ID';


--
-- TOC entry 9765 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.video_title; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.video_title IS '视频标题';


--
-- TOC entry 9766 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.video_url; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.video_url IS '视频URL';


--
-- TOC entry 9767 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.video_duration; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.video_duration IS '视频时长(秒)';


--
-- TOC entry 9768 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.video_size; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.video_size IS '视频大小(字节)';


--
-- TOC entry 9769 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.video_description; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.video_description IS '视频描述';


--
-- TOC entry 9770 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.sort_order; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.sort_order IS '排序号';


--
-- TOC entry 9771 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.is_free; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.is_free IS '是否免费 0-收费 1-免费';


--
-- TOC entry 9772 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.status IS '状态 0-禁用 1-启用';


--
-- TOC entry 9773 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.create_time IS '创建时间';


--
-- TOC entry 9774 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.update_time IS '更新时间';


--
-- TOC entry 608 (class 1259 OID 16763)
-- Name: home_intro; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.home_intro (
    id bigint NOT NULL,
    title character varying(200 char) NOT NULL,
    content longtext NOT NULL,
    sort_order integer DEFAULT 0,
    status tinyint DEFAULT 1 NOT NULL,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.home_intro OWNER TO system;

--
-- TOC entry 9775 (class 0 OID 0)
-- Dependencies: 608
-- Name: TABLE home_intro; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.home_intro IS '首页简介表';


--
-- TOC entry 9776 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.id IS 'ID';


--
-- TOC entry 9777 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.title; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.title IS '标题';


--
-- TOC entry 9778 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.content; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.content IS '内容';


--
-- TOC entry 9779 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.sort_order; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.sort_order IS '排序';


--
-- TOC entry 9780 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.status IS '状态 0-禁用 1-启用';


--
-- TOC entry 9781 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.create_time IS '创建时间';


--
-- TOC entry 9782 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.update_time IS '更新时间';


--
-- TOC entry 604 (class 1259 OID 16736)
-- Name: meeting; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.meeting (
    id bigint NOT NULL,
    meeting_name character varying(200 char) NOT NULL,
    meeting_time datetime NOT NULL,
    meeting_content longtext,
    cover_image character varying(255 char),
    location character varying(200 char),
    organizer character varying(100 char),
    category character varying(50 char),
    creator character varying(50 char) NOT NULL,
    creator_id bigint NOT NULL,
    status tinyint DEFAULT 0 NOT NULL,
    audit_time datetime,
    audit_user_id bigint,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.meeting OWNER TO system;

--
-- TOC entry 9783 (class 0 OID 0)
-- Dependencies: 604
-- Name: TABLE meeting; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.meeting IS '会议表';


--
-- TOC entry 9784 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.id IS '会议ID';


--
-- TOC entry 9785 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.meeting_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.meeting_name IS '会议名称';


--
-- TOC entry 9786 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.meeting_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.meeting_time IS '会议时间';


--
-- TOC entry 9787 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.meeting_content; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.meeting_content IS '会议内容';


--
-- TOC entry 9788 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.cover_image; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.cover_image IS '会议封面';


--
-- TOC entry 9789 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.location; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.location IS '会议地点';


--
-- TOC entry 9790 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.organizer; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.organizer IS '主办单位';


--
-- TOC entry 9791 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.category; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.category IS '会议分类';


--
-- TOC entry 9792 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.creator; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.creator IS '创建人';


--
-- TOC entry 9793 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.creator_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.creator_id IS '创建人ID';


--
-- TOC entry 9794 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.status IS '状态 0-待审核 1-已发布 2-已拒绝';


--
-- TOC entry 9795 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.audit_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.audit_time IS '审核时间';


--
-- TOC entry 9796 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.audit_user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.audit_user_id IS '审核人ID';


--
-- TOC entry 9797 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.create_time IS '创建时间';


--
-- TOC entry 9798 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.update_time IS '更新时间';


--
-- TOC entry 614 (class 1259 OID 16805)
-- Name: meeting_feedback; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.meeting_feedback (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    user_id bigint NOT NULL,
    user_name character varying(100 char),
    company_name character varying(200 char),
    gender character varying(10 char),
    user_phone character varying(20 char),
    user_email character varying(100 char),
    arrival_method character varying(50 char),
    arrival_info character varying(100 char),
    arrival_time character varying(100 char),
    rating integer NOT NULL,
    content text,
    suggestions text,
    organization_rating integer,
    content_rating integer,
    venue_rating integer,
    attachments text,
    submit_time datetime,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.meeting_feedback OWNER TO system;

--
-- TOC entry 9799 (class 0 OID 0)
-- Dependencies: 614
-- Name: TABLE meeting_feedback; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.meeting_feedback IS '参会回执表';


--
-- TOC entry 9800 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.id IS '主键ID';


--
-- TOC entry 9801 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.meeting_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.meeting_id IS '会议ID';


--
-- TOC entry 9802 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.user_id IS '用户ID';


--
-- TOC entry 9803 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.user_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.user_name IS '用户姓名';


--
-- TOC entry 9804 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.company_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.company_name IS '单位名称';


--
-- TOC entry 9805 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.gender; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.gender IS '性别';


--
-- TOC entry 9806 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.user_phone; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.user_phone IS '手机号码';


--
-- TOC entry 9807 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.user_email; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.user_email IS '电子邮箱';


--
-- TOC entry 9808 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.arrival_method; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.arrival_method IS '到达方式';


--
-- TOC entry 9809 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.arrival_info; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.arrival_info IS '到达车次/航班';


--
-- TOC entry 9810 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.arrival_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.arrival_time IS '到达时间';


--
-- TOC entry 9811 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.rating; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.rating IS '总体评分(1-5分)';


--
-- TOC entry 9812 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.content; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.content IS '参会感受';


--
-- TOC entry 9813 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.suggestions; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.suggestions IS '改进建议';


--
-- TOC entry 9814 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.organization_rating; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.organization_rating IS '组织评分(1-5分)';


--
-- TOC entry 9815 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.content_rating; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.content_rating IS '内容评分(1-5分)';


--
-- TOC entry 9816 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.venue_rating; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.venue_rating IS '场地评分(1-5分)';


--
-- TOC entry 9817 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.attachments; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.attachments IS '附件路径，多个用逗号分隔';


--
-- TOC entry 9818 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.submit_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.submit_time IS '提交时间';


--
-- TOC entry 9819 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.create_time IS '创建时间';


--
-- TOC entry 9820 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.update_time IS '更新时间';


--
-- TOC entry 594 (class 1259 OID 16669)
-- Name: meeting_registration; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.meeting_registration (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    user_id bigint NOT NULL,
    user_name character varying(100 char),
    user_phone character varying(20 char),
    user_email character varying(100 char),
    company_name character varying(200 char),
    status integer DEFAULT 0 NOT NULL,
    registration_time datetime,
    checkin_time datetime,
    remarks text,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.meeting_registration OWNER TO system;

--
-- TOC entry 9821 (class 0 OID 0)
-- Dependencies: 594
-- Name: TABLE meeting_registration; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.meeting_registration IS '会议报名记录表';


--
-- TOC entry 9822 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.id IS '主键ID';


--
-- TOC entry 9823 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.meeting_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.meeting_id IS '会议ID';


--
-- TOC entry 9824 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.user_id IS '用户ID';


--
-- TOC entry 9825 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.user_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.user_name IS '用户姓名';


--
-- TOC entry 9826 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.user_phone; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.user_phone IS '用户电话';


--
-- TOC entry 9827 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.user_email; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.user_email IS '用户邮箱';


--
-- TOC entry 9828 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.company_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.company_name IS '公司名称';


--
-- TOC entry 9829 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.status IS '状态：0-已报名，1-已签到，2-已完成，3-已取消';


--
-- TOC entry 9830 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.registration_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.registration_time IS '报名时间';


--
-- TOC entry 9831 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.checkin_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.checkin_time IS '签到时间';


--
-- TOC entry 9832 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.remarks; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.remarks IS '备注';


--
-- TOC entry 9833 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.create_time IS '创建时间';


--
-- TOC entry 9834 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.update_time IS '更新时间';


--
-- TOC entry 606 (class 1259 OID 16747)
-- Name: news; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.news (
    id bigint NOT NULL,
    title character varying(200 char) NOT NULL,
    summary text,
    content longtext NOT NULL,
    cover_image character varying(255 char),
    author character varying(50 char) NOT NULL,
    author_id bigint NOT NULL,
    category character varying(50 char),
    content_images text,
    videos text,
    attachments text,
    status tinyint DEFAULT 0 NOT NULL,
    audit_time datetime,
    audit_user_id bigint,
    view_count integer DEFAULT 0,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.news OWNER TO system;

--
-- TOC entry 9835 (class 0 OID 0)
-- Dependencies: 606
-- Name: TABLE news; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.news IS '行业动态表';


--
-- TOC entry 9836 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.id IS '动态ID';


--
-- TOC entry 9837 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.title; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.title IS '标题';


--
-- TOC entry 9838 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.summary; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.summary IS '简介';


--
-- TOC entry 9839 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.content; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.content IS '内容';


--
-- TOC entry 9840 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.cover_image; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.cover_image IS '封面图片';


--
-- TOC entry 9841 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.author; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.author IS '作者';


--
-- TOC entry 9842 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.author_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.author_id IS '作者ID';


--
-- TOC entry 9843 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.category; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.category IS '新闻分类';


--
-- TOC entry 9844 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.content_images; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.content_images IS '??????URL???(JSON???)';


--
-- TOC entry 9845 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.videos; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.videos IS '??????URL???(JSON???)';


--
-- TOC entry 9846 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.attachments; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.attachments IS '??????URL???(JSON???)';


--
-- TOC entry 9847 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.status IS '状态 0-待审核 1-已发布 2-已拒绝';


--
-- TOC entry 9848 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.audit_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.audit_time IS '审核时间';


--
-- TOC entry 9849 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.audit_user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.audit_user_id IS '审核人ID';


--
-- TOC entry 9850 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.view_count; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.view_count IS '浏览次数';


--
-- TOC entry 9851 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.create_time IS '创建时间';


--
-- TOC entry 9852 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.update_time IS '更新时间';


--
-- TOC entry 602 (class 1259 OID 16726)
-- Name: tenant; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.tenant (
    id bigint NOT NULL,
    tenant_code character varying(50 char) NOT NULL,
    tenant_name character varying(100 char) NOT NULL,
    contact_person character varying(50 char) NOT NULL,
    contact_phone character varying(20 char) NOT NULL,
    status tinyint DEFAULT 1 NOT NULL,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.tenant OWNER TO system;

--
-- TOC entry 9853 (class 0 OID 0)
-- Dependencies: 602
-- Name: TABLE tenant; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.tenant IS '租户表';


--
-- TOC entry 9854 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.id IS '租户ID';


--
-- TOC entry 9855 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.tenant_code; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.tenant_code IS '租户标识';


--
-- TOC entry 9856 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.tenant_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.tenant_name IS '租户名称';


--
-- TOC entry 9857 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.contact_person; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.contact_person IS '联系人';


--
-- TOC entry 9858 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.contact_phone; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.contact_phone IS '联系电话';


--
-- TOC entry 9859 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.status IS '状态 0-禁用 1-启用';


--
-- TOC entry 9860 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.create_time IS '创建时间';


--
-- TOC entry 9861 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.update_time IS '更新时间';


--
-- TOC entry 600 (class 1259 OID 16714)
-- Name: user; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.`user` (
    id bigint NOT NULL,
    username character varying(50 char) NOT NULL,
    password character varying(255 char) NOT NULL,
    phone character varying(20 char),
    email character varying(100 char),
    nickname character varying(50 char),
    gender tinyint DEFAULT 0,
    role character varying(20 char) DEFAULT 'USER'::varchar NOT NULL,
    status tinyint DEFAULT 1 NOT NULL,
    avatar character varying(255 char),
    company_name character varying(100 char),
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.`user` OWNER TO system;

--
-- TOC entry 9862 (class 0 OID 0)
-- Dependencies: 600
-- Name: TABLE `user`; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.`user` IS '用户表';


--
-- TOC entry 9863 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.id IS '用户ID';


--
-- TOC entry 9864 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.username; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.username IS '用户名';


--
-- TOC entry 9865 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.password; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.password IS '密码';


--
-- TOC entry 9866 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.phone; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.phone IS '手机号';


--
-- TOC entry 9867 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.email; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.email IS '邮箱';


--
-- TOC entry 9868 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.nickname; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.nickname IS '昵称';


--
-- TOC entry 9869 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.gender; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.gender IS '性别 0-未知 1-男 2-女';


--
-- TOC entry 9870 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.role; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.role IS '角色 ADMIN-超级管理员 USER-企业用户';


--
-- TOC entry 9871 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.status IS '状态 0-禁用 1-启用';


--
-- TOC entry 9872 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.avatar; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.avatar IS '头像';


--
-- TOC entry 9873 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.company_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.company_name IS '企业名称';


--
-- TOC entry 9874 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.create_time IS '创建时间';


--
-- TOC entry 9875 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.update_time IS '更新时间';


--
-- TOC entry 591 (class 1259 OID 16656)
-- Name: user_behavior; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.user_behavior (
    id bigint NOT NULL,
    user_id bigint,
    action_type character varying(50 char) NOT NULL,
    target_type character varying(50 char) NOT NULL,
    target_id bigint NOT NULL,
    ip_address character varying(50 char),
    user_agent character varying(500 char),
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.user_behavior OWNER TO system;

--
-- TOC entry 9876 (class 0 OID 0)
-- Dependencies: 591
-- Name: TABLE user_behavior; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.user_behavior IS '用户行为分析表';


--
-- TOC entry 9877 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.id IS 'ID';


--
-- TOC entry 9878 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.user_id IS '用户ID';


--
-- TOC entry 9879 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.action_type; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.action_type IS '行为类型';


--
-- TOC entry 9880 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.target_type; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.target_type IS '目标类型';


--
-- TOC entry 9881 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.target_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.target_id IS '目标ID';


--
-- TOC entry 9882 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.ip_address; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.ip_address IS 'IP地址';


--
-- TOC entry 9883 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.user_agent; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.user_agent IS '用户代理';


--
-- TOC entry 9884 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.create_time IS '创建时间';


--
-- TOC entry 598 (class 1259 OID 16700)
-- Name: user_favorite; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.user_favorite (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    favorite_type character varying(20 char) NOT NULL,
    favorite_id bigint NOT NULL,
    favorite_title character varying(200 char),
    favorite_summary text,
    favorite_cover character varying(500 char),
    favorite_author character varying(50 char),
    create_time datetime DEFAULT CURRENT_TIMESTAMP,
    update_time datetime DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE cemenghui_now.user_favorite OWNER TO system;

--
-- TOC entry 9885 (class 0 OID 0)
-- Dependencies: 598
-- Name: TABLE user_favorite; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.user_favorite IS '用户收藏表';


--
-- TOC entry 9886 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.id IS 'ID';


--
-- TOC entry 9887 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.user_id IS '用户ID';


--
-- TOC entry 9888 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_type; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_type IS '收藏类型 course:课程 meeting:会议 news:新闻';


--
-- TOC entry 9889 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_id IS '被收藏内容的ID';


--
-- TOC entry 9890 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_title; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_title IS '被收藏内容的标题';


--
-- TOC entry 9891 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_summary; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_summary IS '被收藏内容的摘要';


--
-- TOC entry 9892 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_cover; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_cover IS '被收藏内容的封面';


--
-- TOC entry 9893 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_author; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_author IS '被收藏内容的作者';


--
-- TOC entry 9894 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.create_time IS '创建时间';


--
-- TOC entry 9895 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.update_time IS '更新时间';


--
-- TOC entry 616 (class 1259 OID 16812)
-- Name: user_video_progress; Type: TABLE; Schema: cemenghui_now; Owner: system
--

CREATE TABLE cemenghui_now.user_video_progress (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    course_id bigint NOT NULL,
    video_id bigint NOT NULL,
    watch_progress integer DEFAULT 0,
    watch_percentage numeric(5,2) DEFAULT 0.00::numeric(3,2),
    is_completed tinyint DEFAULT 0,
    last_watch_time datetime,
    total_watch_time integer DEFAULT 0,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui_now.user_video_progress OWNER TO system;

--
-- TOC entry 9896 (class 0 OID 0)
-- Dependencies: 616
-- Name: TABLE user_video_progress; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON TABLE cemenghui_now.user_video_progress IS '用户视频学习进度表';


--
-- TOC entry 9897 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.id IS '记录ID';


--
-- TOC entry 9898 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.user_id IS '用户ID';


--
-- TOC entry 9899 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.course_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.course_id IS '课程ID';


--
-- TOC entry 9900 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.video_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.video_id IS '视频ID';


--
-- TOC entry 9901 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.watch_progress; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.watch_progress IS '观看进度(秒)';


--
-- TOC entry 9902 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.watch_percentage; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.watch_percentage IS '观看百分比';


--
-- TOC entry 9903 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.is_completed; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.is_completed IS '是否完成 0-未完成 1-已完成';


--
-- TOC entry 9904 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.last_watch_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.last_watch_time IS '最后观看时间';


--
-- TOC entry 9905 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.total_watch_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.total_watch_time IS '总观看时长(秒)';


--
-- TOC entry 9906 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.create_time IS '创建时间';


--
-- TOC entry 9907 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.update_time IS '更新时间';


--
-- TOC entry 9711 (class 0 OID 16775)
-- Dependencies: 610
-- Data for Name: banner; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.banner (id, title, image_url, link_url, sort_order, status, create_time, update_time) FROM stdin;
1	测试技术大会2024	/uploads/banner1.jpg	/news/1	1	1	2025-06-22 00:57:07	2025-06-22 00:57:07
2	自动化测试工具推荐	/uploads/banner2.jpg	/course/1	2	1	2025-06-22 00:57:07	2025-06-22 00:57:07
3	测试行业发展报告	/uploads/banner3.jpg	/news/2	3	1	2025-06-22 00:57:07	2025-06-22 00:57:07
4	欢迎来到测盟汇	/uploads/banner1.jpg	/pages/about	1	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	最新测试技术动态	/uploads/banner2.jpg	/pages/news	2	1	2025-06-22 03:11:04	2025-06-22 03:11:04
6	专业课程培训	/uploads/banner3.jpg	/pages/course	3	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- TOC entry 9697 (class 0 OID 16687)
-- Dependencies: 596
-- Data for Name: course; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.course (id, course_name, course_summary, cover_image, video_url, author, author_id, sort_order, status, audit_time, audit_user_id, view_count, create_time, update_time) FROM stdin;
1	软件测试基础入门课程	适合零基础学员的软件测试入门课程，涵盖测试理论、方法和实践	/uploads/bb4c7878-0cff-43c5-8379-88bb9e62904b.png	/uploads/fbd3931e-ae39-46e3-921a-25c61c8f0606.mp4	超级管理员	1	1	1	\N	\N	464	2025-06-22 03:11:04	2025-07-04 15:21:03
2	Selenium自动化测试实战	通过实际项目案例学习Selenium自动化测试技术	/uploads/21a8d2ac-2535-46d7-9889-9d3e674dad97.png	/uploads/course2.mp4	企业用户1	2	2	1	\N	\N	390	2025-06-22 03:11:04	2025-06-22 03:11:04
3	性能测试进阶课程	深入学习性能测试的理论和实践，掌握JMeter等工具的使用	/uploads/29389910-ed5a-4870-aa49-25ecbe4e35a8.png	/uploads/course3.mp4	企业用户2	3	3	1	\N	\N	280	2025-06-22 03:11:04	2025-06-22 03:11:04
4	移动应用测试专项训练	专门针对移动应用测试的课程，包含Android和iOS测试技巧	/uploads/1eca3f70-6eda-4779-8d0e-cf5f103f3e06.png	/uploads/course4.mp4	企业用户3	4	4	1	\N	\N	203	2025-06-22 03:11:04	2025-06-22 03:11:04
9	1	1			企业用户1	2	0	0	\N	\N	4	2025-06-22 07:08:18	2025-06-22 07:08:18
6	测试管理与团队建设	测试团队管理、测试流程优化、质量保障体系建设	/uploads/618b4471-dfda-40b2-907b-a4e70968a582.png	/uploads/8e3b7ca5-b48a-4fc1-b2d4-d186704d8198.mp4	企业用户1	2	6	1	2025-06-22 04:54:24	1	176	2025-06-22 03:11:04	2025-06-22 03:46:42
5	API接口测试实战	学习使用Postman、Python等工具进行API接口测试	/uploads/ee62e8f1-6c1d-420c-a3bb-182e7772db43.png	/uploads/course5.mp4	超级管理员	1	5	1	\N	\N	366	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- TOC entry 9693 (class 0 OID 16661)
-- Dependencies: 592
-- Data for Name: course_enrollment; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.course_enrollment (id, course_id, user_id, user_name, user_email, user_phone, progress, status, enrollment_time, start_time, complete_time, create_time, update_time) FROM stdin;
1	6	9	user3	user3@qq.com	\N	0	0	2025-06-24 15:52:05	\N	\N	2025-06-24 15:52:05	2025-06-24 15:52:05
2	10	12	微信用户	\N	\N	0	0	2025-06-24 19:25:03	\N	\N	2025-06-24 19:25:03	2025-06-24 19:25:02
\.


--
-- TOC entry 9713 (class 0 OID 16788)
-- Dependencies: 612
-- Data for Name: course_video; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.course_video (id, course_id, video_title, video_url, video_duration, video_size, video_description, sort_order, is_free, status, create_time, update_time) FROM stdin;
1	1	第1章：软件测试基础概念	/uploads/fbd3931e-ae39-46e3-921a-25c61c8f0606.mp4	1800	0	介绍软件测试的基本概念、目的和重要性	1	1	1	2025-06-24 16:09:27	2025-07-04 15:21:04
2	1	第2章：测试方法与分类	/uploads/video1_2.mp4	2100	0	详细讲解黑盒测试、白盒测试、灰盒测试等测试方法	2	0	1	2025-06-24 16:09:27	2025-07-04 15:21:04
3	1	第3章：测试用例设计	/uploads/video1_3.mp4	2400	0	学习如何设计有效的测试用例	3	0	1	2025-06-24 16:09:27	2025-07-04 15:21:04
4	1	第4章：缺陷管理	/uploads/video1_4.mp4	1950	0	缺陷的发现、记录、跟踪和管理流程	4	0	1	2025-06-24 16:09:27	2025-07-04 15:21:04
5	2	第1章：Selenium环境搭建	/uploads/video2_1.mp4	1200	0	Selenium WebDriver环境配置和基本使用	1	1	1	2025-06-24 16:09:27	2025-06-24 16:09:27
6	2	第2章：元素定位策略	/uploads/video2_2.mp4	1800	0	掌握各种元素定位方法和最佳实践	2	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
7	2	第3章：页面对象模式	/uploads/video2_3.mp4	2200	0	学习POM设计模式提高代码可维护性	3	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
8	2	第4章：数据驱动测试	/uploads/video2_4.mp4	2000	0	实现数据驱动的自动化测试框架	4	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
9	2	第5章：测试报告生成	/uploads/video2_5.mp4	1500	0	生成详细的测试报告和结果分析	5	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
10	3	第1章：性能测试理论基础	/uploads/video3_1.mp4	1600	0	性能测试的基本概念和理论知识	1	1	1	2025-06-24 16:09:27	2025-06-24 16:09:27
11	3	第2章：JMeter工具使用	/uploads/video3_2.mp4	2500	0	JMeter工具的详细使用教程	2	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
12	3	第3章：性能测试脚本编写	/uploads/video3_3.mp4	2800	0	编写复杂的性能测试脚本	3	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
13	3	第4章：性能监控与分析	/uploads/video3_4.mp4	2200	0	性能监控指标分析和瓶颈定位	4	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
14	4	第1章：移动测试概述	/uploads/video4_1.mp4	1400	0	移动应用测试的特点和挑战	1	1	1	2025-06-24 16:09:27	2025-06-24 16:09:27
15	4	第2章：Android测试工具	/uploads/video4_2.mp4	2000	0	Android应用测试工具和方法	2	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
16	4	第3章：iOS测试实践	/uploads/video4_3.mp4	1900	0	iOS应用测试的实践经验	3	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
17	4	第4章：兼容性测试	/uploads/video4_4.mp4	2300	0	移动设备兼容性测试策略	4	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
18	5	第1章：API测试基础	/uploads/video5_1.mp4	1300	0	API接口测试的基本知识	1	1	1	2025-06-24 16:09:27	2025-06-24 16:09:27
19	5	第2章：Postman实战	/uploads/video5_2.mp4	1700	0	Postman工具的高级使用技巧	2	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
20	5	第3章：自动化接口测试	/uploads/video5_3.mp4	2100	0	使用Python进行API自动化测试	3	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
21	5	第4章：接口测试框架	/uploads/video5_4.mp4	2400	0	构建完整的接口测试框架	4	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
\.


--
-- TOC entry 9709 (class 0 OID 16763)
-- Dependencies: 608
-- Data for Name: home_intro; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.home_intro (id, title, content, sort_order, status, create_time, update_time) FROM stdin;
1	关于测盟汇	<p>测盟汇是专业的测试行业交流平台，致力于推动测试技术发展...</p>	1	1	2025-06-22 00:57:07	2025-06-22 00:57:07
2	我们的使命	<p>通过技术分享、经验交流，提升整个行业的测试水平...</p>	2	1	2025-06-22 00:57:07	2025-06-22 00:57:07
3	联系我们	<p>地址：北京市朝阳区xxx<br>电话：400-123-4567<br>邮箱：info@cemenghui.com</p>	3	1	2025-06-22 00:57:07	2025-06-22 00:57:07
4	测盟汇平台介绍	<h2>专业的测试技术交流平台</h2><p>测盟汇致力于为软件测试从业者提供专业的技术交流、学习和合作平台。我们汇聚了行业内的优秀专家和企业，共同推动测试技术的发展和创新。</p>	1	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	平台特色服务	<h3>? 技术分享</h3><p>定期发布最新的测试技术文章和行业动态</p><h3>? 在线课程</h3><p>提供系统化的测试技术培训课程</p><h3>? 合作会议</h3><p>组织各类测试技术交流会议和培训活动</p>	2	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- TOC entry 9705 (class 0 OID 16736)
-- Dependencies: 604
-- Data for Name: meeting; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.meeting (id, meeting_name, meeting_time, meeting_content, cover_image, location, organizer, category, creator, creator_id, status, audit_time, audit_user_id, create_time, update_time) FROM stdin;
1	2025年软件测试技术峰会	2025-06-25 09:00:00	<h2>会议简介</h2><p>本次峰会将汇聚国内外软件测试领域的专家学者和行业精英，共同探讨软件测试技术的最新发展趋势。</p><h2>会议议程</h2><ul><li>09:00-09:30 开幕式</li><li>09:30-10:30 主题演讲：AI在测试中的应用</li><li>10:30-11:30 圆桌讨论：测试自动化的未来</li><li>14:00-15:00 技术分享：云原生测试实践</li><li>15:00-16:00 案例分析：大型项目测试经验</li></ul>	/uploads/9f98ef04-14eb-48fd-ae70-a114b4b8c21d.png	北京国际会议中心	测盟汇	技术峰会	超级管理员	1	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
2	自动化测试工具培训班	2024-07-20 14:00:00	<h2>培训内容</h2><p>为期两天的自动化测试工具深度培训，包括理论学习和实际操作。</p><h2>培训安排</h2><ul><li>第一天：Selenium WebDriver基础</li><li>第二天：高级功能和最佳实践</li></ul><h2>适合人群</h2><p>有一定测试基础的工程师</p>	/uploads/8fa76bff-3483-4aaa-b9ea-23b4ca394ae7.png	上海技术培训中心	测试技术联盟	技术培训	企业用户1	2	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
3	测试标准制定研讨会	2024-08-10 10:00:00	<h2>研讨主题</h2><p>讨论制定新的行业测试标准，提升整个行业的测试质量。</p><h2>参会对象</h2><ul><li>测试管理专家</li><li>质量保障负责人</li><li>标准制定委员会成员</li></ul>	/uploads/665f774b-262f-42ef-a825-501aeeab51f0.png	深圳会展中心	标准化委员会	标准制定	企业用户2	3	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
4	性能测试实战工作坊	2024-09-05 13:30:00	<h2>工作坊内容</h2><p>通过实际案例学习性能测试的完整流程。</p><h2>学习目标</h2><ul><li>掌握性能测试计划制定</li><li>学会使用JMeter进行压力测试</li><li>分析性能测试结果</li></ul>	/uploads/77696977-5b78-4946-9775-2c079cdfa69b.png	杭州西湖国际会议中心	性能测试协会	实战工作坊	企业用户3	4	0	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
5	移动应用测试交流会	2024-10-12 15:00:00	<h2>交流内容</h2><p>分享移动应用测试的最新技术和经验。</p><h2>议题安排</h2><ul><li>iOS自动化测试实践</li><li>Android兼容性测试</li><li>移动应用性能优化</li></ul>	/uploads/9caf57fe-182b-4141-abb4-d1d483179642.png	广州天河会议中心	移动测试联盟	技术交流	超级管理员	1	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
7	软件测试技术发展趋势研讨会	2025-07-17 19:43:55	<h2>会议主题</h2><p>探讨软件测试技术的最新发展趋势，包括自动化测试、AI测试、云测试等前沿技术。</p><h2>议程安排</h2><ul><li>09:00-09:30 开幕式</li><li>09:30-10:30 主题演讲：AI在测试中的应用</li><li>10:45-11:45 技术分享：云原生测试实践</li><li>14:00-15:00 圆桌讨论：测试行业未来展望</li></ul>	/uploads/73bc8ae9-478f-491b-b925-7bde348524d7.png	北京国际会议中心	中国软件测试协会	研讨	超级管理员	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
8	移动应用测试技术交流会	2025-07-04 03:59:51	<h2>交流内容</h2><p>分享移动应用测试的最新技术和实践经验，包括iOS、Android平台的测试策略。</p><h2>技术议题</h2><ul><li>移动端自动化测试框架对比</li><li>性能测试在移动应用中的应用</li><li>兼容性测试最佳实践</li></ul>	/uploads/e3a2302c-c638-40f7-ba88-7b9831d03ac8.png	上海科技大厦	移动测试联盟	研讨	超级管理员	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
9	软件测试标准制定工作会议	2024-12-26 02:00:00	<h2>工作目标</h2><p>制定行业软件测试标准，规范测试流程和质量要求。</p><h2>工作内容</h2><ul><li>测试流程标准化讨论</li><li>质量标准制定</li><li>工具选型标准</li><li>人员能力要求</li></ul>	/uploads/05fd484a-e83e-4d75-9f31-67a78aed424c.png	深圳软件园	国家软件测试标准化委员会	标准定制	超级管理员	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
10	企业测试体系定制咨询会	2025-07-11 01:30:00	<h2>咨询内容</h2><p>为企业提供定制化的测试体系建设方案，包括流程设计、工具选型、团队建设等。</p><h2>服务内容</h2><ul><li>测试流程设计</li><li>工具链规划</li><li>团队能力建设</li><li>质量度量体系</li></ul>	/uploads/ba9daa9f-30d8-45cc-bae7-89fef860ad5d.png	广州天河软件园	测试咨询专家团	标准定制	超级管理员	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
11	自动化测试技能提升培训班	2024-12-30 09:00:00	<h2>培训目标</h2><p>提升测试人员的自动化测试技能，掌握主流自动化测试工具和框架。</p><h2>培训内容</h2><ul><li>Selenium WebDriver实战</li><li>Appium移动端自动化</li><li>接口自动化测试</li><li>持续集成与测试</li></ul>	/uploads/65c43dcd-d7be-4705-bbf3-87948e41c4cb.png	杭州西湖软件园	测试技术培训中心	技术培训	超级管理员	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
12	性能测试工程师认证培训	2025-01-05 09:00:00	<h2>认证目标</h2><p>培养专业的性能测试工程师，掌握性能测试的完整流程和技术。</p><h2>培训大纲</h2><ul><li>性能测试基础理论</li><li>JMeter工具使用</li><li>性能监控与分析</li><li>性能优化策略</li></ul>	/uploads/44dfff36-802b-4baa-9803-6d1f7a62e174.png	成都高新区	性能测试认证中心	技术培训	超级管理员	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
13	测试工具开发技术研讨会	2025-01-10 14:00:00	<h2>研讨主题</h2><p>探讨测试工具开发的技术趋势和最佳实践，分享开源测试工具的开发和维护经验。</p><h2>技术分享</h2><ul><li>测试工具架构设计</li><li>插件化测试框架开发</li><li>AI驱动的测试工具</li><li>开源项目维护经验</li></ul>	/uploads/21e8d110-ed7a-471a-8015-24f0d5a55630.png	武汉光谷软件园	测试工具开发者联盟	工具研发	超级管理员	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
14	开源测试工具贡献者大会	2025-01-15 09:00:00	<h2>大会目标</h2><p>汇聚开源测试工具的贡献者，共同探讨开源项目的发展方向和协作模式。</p><h2>活动内容</h2><ul><li>开源项目展示</li><li>技术分享与交流</li><li>协作模式讨论</li><li>未来发展规划</li></ul>	/uploads/d93f222d-8d8a-44e0-b838-6df79e908ca2.png	西安软件园	开源测试工具社区	工具研发	超级管理员	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
15	软件测试公益培训计划启动会	2025-01-20 10:00:00	<h2>公益目标</h2><p>为偏远地区的学生和从业者提供免费的软件测试培训，推动测试技术的普及。</p><h2>计划内容</h2><ul><li>在线课程开发</li><li>线下培训安排</li><li>志愿者招募</li><li>资金募集计划</li></ul>	/uploads/6c7121d6-7800-4d37-b1a7-3826af4978c4.png	北京中关村	测试技术公益基金会	公益行动	超级管理员	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
16	测试行业社会责任论坛	2025-01-25 14:00:00	<h2>论坛主题</h2><p>探讨测试行业在推动软件质量提升、保护用户权益方面的社会责任。</p><h2>讨论议题</h2><ul><li>软件质量与用户安全</li><li>测试行业的伦理责任</li><li>行业标准与规范</li><li>社会影响力提升</li></ul>	/uploads/c86d777a-75df-4e21-98df-9ca7449d8fd5.png	深圳南山	软件测试社会责任联盟	公益行动	超级管理员	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
\.


--
-- TOC entry 9715 (class 0 OID 16805)
-- Dependencies: 614
-- Data for Name: meeting_feedback; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.meeting_feedback (id, meeting_id, user_id, user_name, company_name, gender, user_phone, user_email, arrival_method, arrival_info, arrival_time, rating, content, suggestions, organization_rating, content_rating, venue_rating, attachments, submit_time, create_time, update_time) FROM stdin;
1	1	9	user3	\N	\N	\N	\N	\N	\N	\N	3	会议挺好的		0	0	0	\N	2025-06-24 15:17:18	2025-06-24 15:17:18	2025-06-24 15:17:17
2	7	9	user3	1	男	1	1	汽车	1	1	3	1	1	0	0	0	\N	2025-07-04 11:44:27	2025-07-04 11:44:27	2025-07-04 11:44:26
3	8	9	user3	1	男	1	1	火车	1	1	3	11	1	2	2	2	\N	2025-07-04 12:00:23	2025-07-04 12:00:23	2025-07-04 12:00:22
\.


--
-- TOC entry 9695 (class 0 OID 16669)
-- Dependencies: 594
-- Data for Name: meeting_registration; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.meeting_registration (id, meeting_id, user_id, user_name, user_phone, user_email, company_name, status, registration_time, checkin_time, remarks, create_time, update_time) FROM stdin;
1	1	9	user3	\N	user3@qq.com	\N	0	2025-06-24 15:08:54	\N	\N	2025-06-24 15:08:54	2025-06-24 15:08:54
2	1	12	微信用户	\N	\N	\N	0	2025-06-24 19:26:03	\N	\N	2025-06-24 19:26:03	2025-06-24 19:26:03
3	7	9	user3	\N	user3@qq.com	\N	0	2025-07-04 11:43:19	\N	\N	2025-07-04 11:43:19	2025-07-04 11:43:18
4	8	9	user3	\N	user3@qq.com	\N	0	2025-07-04 11:59:45	\N	\N	2025-07-04 11:59:45	2025-07-04 11:59:44
\.


--
-- TOC entry 9707 (class 0 OID 16747)
-- Dependencies: 606
-- Data for Name: news; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.news (id, title, summary, content, cover_image, author, author_id, category, content_images, videos, attachments, status, audit_time, audit_user_id, view_count, create_time, update_time) FROM stdin;
2	自动化测试工具深度对比分析	详细对比市面上主流的自动化测试工具的优缺点和适用场景	<h2>Selenium WebDriver</h2><p><strong>优点：</strong></p><ul><li>开源免费</li><li>支持多种编程语言</li><li>社区活跃</li></ul><p><strong>缺点：</strong></p><ul><li>配置相对复杂</li><li>执行速度较慢</li></ul><h2>Cypress</h2><p><strong>优点：</strong></p><ul><li>易于使用和调试</li><li>执行速度快</li><li>实时重载</li></ul><p><strong>缺点：</strong></p><ul><li>仅支持JavaScript</li><li>浏览器支持有限</li></ul>	/uploads/be4f21a2-80b4-4580-90b2-76d67a2b5da0.png	企业用户1	2	行业动态	\N	\N	\N	0	\N	\N	193	2025-06-22 03:11:04	2025-06-22 21:11:14
3	敏捷开发中的测试策略	探讨在敏捷开发环境下如何制定有效的测试策略	<h2>敏捷测试的核心理念</h2><p>敏捷测试强调早期介入、持续测试、快速反馈。</p><h2>测试左移策略</h2><p>将测试活动前移到开发早期阶段，包括需求分析、设计阶段。</p><h2>自动化测试在敏捷中的作用</h2><p>自动化测试是敏捷开发成功的关键因素之一。</p>	/uploads/66ed6f51-571d-4783-b213-9677634573a1.png	企业用户2	3	行业动态	\N	\N	\N	1	\N	\N	146	2025-06-22 03:11:04	2025-06-22 21:11:14
4	性能测试最佳实践指南	分享大型系统性能测试的经验和最佳实践	<h2>性能测试规划</h2><p>制定详细的性能测试计划，明确测试目标和场景。</p><h2>测试环境准备</h2><p>搭建与生产环境相似的测试环境。</p><h2>监控和分析</h2><p>实时监控系统性能指标，及时发现性能瓶颈。</p>	/uploads/5d6d114e-3fba-4f9e-bdf4-c87386d4c7c6.png	超级管理员	1	行业动态	\N	\N	\N	1	\N	\N	105	2025-06-22 03:11:04	2025-06-22 21:11:14
5	移动应用测试技术要点	移动应用测试的特点和关键技术点分析	<h2>移动测试的挑战</h2><p>设备碎片化、网络环境复杂、用户体验要求高。</p><h2>兼容性测试</h2><p>确保应用在不同设备和系统版本上正常运行。</p><h2>性能优化</h2><p>关注应用启动时间、内存使用、电池消耗等指标。</p>	/uploads/d05899a8-d07f-4e33-800c-a79cec30e658.png	企业用户3	4	行业动态	\N	\N	\N	0	\N	\N	67	2025-06-22 03:11:04	2025-06-22 21:11:14
1	2025年软件测试技术发展趋势	深入分析软件测试行业的最新发展趋势和技术变革	<h2>引言</h2><p>随着软件开发技术的快速发展，测试技术也在不断演进和创新。本文将深入分析2024年软件测试技术的发展趋势。</p><h2>AI驱动的测试自动化</h2><p>人工智能技术在测试领域的应用越来越广泛，包括智能测试用例生成、自动化缺陷检测等。</p><h2>云原生测试</h2><p>随着云计算技术的普及，云原生测试成为新的发展方向。</p>	/uploads/2dfe70bd-c805-490e-aa3c-ad4b323ccb83.png	超级管理员	1	行业动态	\N	\N	\N	1	\N	\N	277	2025-06-22 03:11:04	2025-06-22 21:11:14
\.


--
-- TOC entry 9703 (class 0 OID 16726)
-- Dependencies: 602
-- Data for Name: tenant; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.tenant (id, tenant_code, tenant_name, contact_person, contact_phone, status, create_time, update_time) FROM stdin;
1	T001	测试科技有限公司	张经理	13800138001	1	2025-06-22 03:11:04	2025-06-22 03:11:04
2	T002	软件测试公司	李经理	13800138002	1	2025-06-22 03:11:04	2025-06-22 03:11:04
3	T003	质量保障中心	王经理	13800138003	1	2025-06-22 03:11:04	2025-06-22 03:11:04
4	T004	自动化测试实验室	赵经理	13800138004	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	T005	性能测试中心	刘经理	13800138005	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- TOC entry 9701 (class 0 OID 16714)
-- Dependencies: 600
-- Data for Name: user; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.`user` (id, username, password, phone, email, nickname, gender, role, status, avatar, company_name, create_time, update_time) FROM stdin;
1	admin	$2a$10$Grdj6ESzHmPKE48jrrvGteliUNgkxYVeyh6YvYR3jzFLWRqLvcr.K	13800138000	admin@cemenghui.com	超级管理员	1	ADMIN	1	/uploads/fea83ca4-ee1e-439c-88ed-10ca3c95ac4f.jpeg	测盟汇总部	2025-06-22 03:11:04	2025-06-22 03:12:28
2	company1	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138001	company1@test.com	企业用户1	0	USER	1	/uploads/9480f065-7014-44ac-8301-7d86d6131f78.jpg	测试科技有限公司	2025-06-22 03:11:04	2025-06-22 04:03:05
3	company2	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138002	company2@test.com	企业用户2	0	USER	1	\N	软件测试公司	2025-06-22 03:11:04	2025-06-22 03:12:28
4	company3	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138003	company3@test.com	企业用户3	0	USER	1	\N	质量保障中心	2025-06-22 03:11:04	2025-06-22 03:12:28
5	user1	$2a$10$yMRyuyW0FIqBnPIB2aj/DuudYqIF1erdwYu6W5dEUvybwYIltIp8C	1	1@qq.com	1	2	USER	1	/uploads/4d0bf446-01d6-47d0-bc8c-01bb16a88f3d.jpg	1	2025-06-22 03:12:13	2025-06-22 03:12:13
7	user2	$2a$10$IjyrV3VJzmGoWPg.Bk8Xv.J4WRIPLtoC8dXhDbU6ji4.v3uYhdD4G	\N	484855425@163.com	\N	0	USER	1	\N	\N	2025-06-22 06:08:06	2025-06-22 06:08:06
8	1111	$2a$10$sqwqQwaW016nKyHBE0.KHe1E3MnpZQyhQYHRCMECAGKqmt7GAOEAy	15115151515	15115151515@qq.com	\N	0	USER	1	\N	1	2025-06-22 23:19:30	2025-06-22 23:19:30
9	user3	$2a$10$rgekPmtXa.BS0vaoCG1mX.YiOXpKHPXSFTdRrO3u9wmFyTgNibSRu	\N	user3@qq.com	\N	0	USER	1	\N	\N	2025-06-24 14:24:50	2025-06-24 14:24:50
10	user4	$2a$10$xv1zEWjbqJ.CyVgvFoiPyeeu.n34M/BcqO./fXmozGy0wmbsA0cQ6	\N	user4@163.com	\N	0	USER	1	\N	\N	2025-06-24 14:47:41	2025-06-24 14:47:41
11	wx_1750763401213	wechat_user	\N	99@qq.com	微信用户	0	USER	1	/uploads/3c80122c-6633-49b6-a8ef-aac4e07cc6e9.jpeg	\N	2025-06-24 19:10:01	2025-06-24 19:10:01
12	wx_1750764285398	wechat_user	\N	\N	微信用户	0	USER	1	https://thirdwx.qlogo.cn/mmopen/vi_32/POgEwh4mIHO4nibH0KlMECNjjGxQUq24ZEaGT4poC6icRiccVGKSyXwibcPq4BWmiaIGuG1icwxaQX6grC9VemZoJ8rg/132	\N	2025-06-24 19:24:45	2025-06-24 19:24:45
13	111111	$2a$10$Y26RWR049TAvevrcmDUwdOL5aloTPzySr/.TybP.n0VDoXvQwaO5i	\N	13624002371@163.com	\N	0	USER	1	\N	\N	2025-07-05 15:17:50	2025-07-05 15:17:50
\.


--
-- TOC entry 9692 (class 0 OID 16656)
-- Dependencies: 591
-- Data for Name: user_behavior; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.user_behavior (id, user_id, action_type, target_type, target_id, ip_address, user_agent, create_time) FROM stdin;
1	2	VIEW	NEWS	1	192.168.1.100	\N	2025-06-22 03:11:04
2	3	VIEW	COURSE	1	192.168.1.101	\N	2025-06-22 03:11:04
3	4	REGISTER	MEETING	1	192.168.1.102	\N	2025-06-22 03:11:04
4	2	VIEW	NEWS	2	192.168.1.100	\N	2025-06-22 03:11:04
5	3	VIEW	COURSE	2	192.168.1.101	\N	2025-06-22 03:11:04
\.


--
-- TOC entry 9699 (class 0 OID 16700)
-- Dependencies: 598
-- Data for Name: user_favorite; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.user_favorite (id, user_id, favorite_type, favorite_id, favorite_title, favorite_summary, favorite_cover, favorite_author, create_time, update_time) FROM stdin;
5	12	course	10	第一节	第一节		超级管理员	2025-06-24 19:26:48	2025-06-24 19:26:47
\.


--
-- TOC entry 9717 (class 0 OID 16812)
-- Dependencies: 616
-- Data for Name: user_video_progress; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.user_video_progress (id, user_id, course_id, video_id, watch_progress, watch_percentage, is_completed, last_watch_time, total_watch_time, create_time, update_time) FROM stdin;
4	9	3	10	0	0.00	0	2025-06-24 18:15:31	66	2025-06-24 18:15:31	2025-06-24 18:15:31
7	13	5	18	0	0.00	0	2025-07-05 15:23:20	1751700200	2025-07-05 15:23:20	2025-07-05 15:23:20
\.


--
-- TOC entry 609 (class 1259 OID 16770)
-- Name: banner_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.banner ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.banner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 7;


--
-- TOC entry 9908 (class 0 OID 0)
-- Dependencies: 609
-- Name: banner_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.banner_id_seq', 6, true);


--
-- TOC entry 590 (class 1259 OID 16654)
-- Name: course_enrollment_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.course_enrollment ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.course_enrollment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 3;


--
-- TOC entry 9909 (class 0 OID 0)
-- Dependencies: 590
-- Name: course_enrollment_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.course_enrollment_id_seq', 2, true);


--
-- TOC entry 595 (class 1259 OID 16685)
-- Name: course_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.course ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.course_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 11;


--
-- TOC entry 9910 (class 0 OID 0)
-- Dependencies: 595
-- Name: course_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.course_id_seq', 9, true);


--
-- TOC entry 611 (class 1259 OID 16786)
-- Name: course_video_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.course_video ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.course_video_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 33;


--
-- TOC entry 9911 (class 0 OID 0)
-- Dependencies: 611
-- Name: course_video_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.course_video_id_seq', 21, true);


--
-- TOC entry 607 (class 1259 OID 16761)
-- Name: home_intro_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.home_intro ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.home_intro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 6;


--
-- TOC entry 9912 (class 0 OID 0)
-- Dependencies: 607
-- Name: home_intro_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.home_intro_id_seq', 5, true);


--
-- TOC entry 613 (class 1259 OID 16801)
-- Name: meeting_feedback_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.meeting_feedback ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.meeting_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 4;


--
-- TOC entry 9913 (class 0 OID 0)
-- Dependencies: 613
-- Name: meeting_feedback_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.meeting_feedback_id_seq', 3, true);


--
-- TOC entry 603 (class 1259 OID 16734)
-- Name: meeting_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.meeting ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.meeting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 17;


--
-- TOC entry 9914 (class 0 OID 0)
-- Dependencies: 603
-- Name: meeting_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.meeting_id_seq', 16, true);


--
-- TOC entry 593 (class 1259 OID 16667)
-- Name: meeting_registration_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.meeting_registration ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.meeting_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 5;


--
-- TOC entry 9915 (class 0 OID 0)
-- Dependencies: 593
-- Name: meeting_registration_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.meeting_registration_id_seq', 4, true);


--
-- TOC entry 605 (class 1259 OID 16745)
-- Name: news_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.news ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 10;


--
-- TOC entry 9916 (class 0 OID 0)
-- Dependencies: 605
-- Name: news_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.news_id_seq', 5, true);


--
-- TOC entry 601 (class 1259 OID 16724)
-- Name: tenant_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.tenant ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.tenant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 7;


--
-- TOC entry 9917 (class 0 OID 0)
-- Dependencies: 601
-- Name: tenant_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.tenant_id_seq', 5, true);


--
-- TOC entry 589 (class 1259 OID 16653)
-- Name: user_behavior_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.user_behavior ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.user_behavior_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 6;


--
-- TOC entry 9918 (class 0 OID 0)
-- Dependencies: 589
-- Name: user_behavior_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.user_behavior_id_seq', 5, true);


--
-- TOC entry 597 (class 1259 OID 16698)
-- Name: user_favorite_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.user_favorite ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.user_favorite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 6;


--
-- TOC entry 9919 (class 0 OID 0)
-- Dependencies: 597
-- Name: user_favorite_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.user_favorite_id_seq', 5, true);


--
-- TOC entry 599 (class 1259 OID 16712)
-- Name: user_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.`user` ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 14;


--
-- TOC entry 9920 (class 0 OID 0)
-- Dependencies: 599
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.user_id_seq', 13, true);


--
-- TOC entry 615 (class 1259 OID 16810)
-- Name: user_video_progress_id_seq; Type: SEQUENCE; Schema: cemenghui_now; Owner: system
--

ALTER TABLE cemenghui_now.user_video_progress ALTER COLUMN id ADD AUTO_INCREMENT (
    SEQUENCE NAME cemenghui_now.user_video_progress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
), AUTO_INCREMENT = 8;


--
-- TOC entry 9921 (class 0 OID 0)
-- Dependencies: 615
-- Name: user_video_progress_id_seq; Type: SEQUENCE SET; Schema: cemenghui_now; Owner: system
--

SELECT pg_catalog.setval('cemenghui_now.user_video_progress_id_seq', 7, true);


--
-- TOC entry 9206 (class 2606 OID 16723)
-- Name: user PRIMARY_196A79C6; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.`user`
    ADD CONSTRAINT `PRIMARY_196A79C6` PRIMARY KEY (id);


--
-- TOC entry 9230 (class 2606 OID 16804)
-- Name: course_video PRIMARY_24128D52; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.course_video
    ADD CONSTRAINT `PRIMARY_24128D52` PRIMARY KEY (id);


--
-- TOC entry 9244 (class 2606 OID 16822)
-- Name: user_video_progress PRIMARY_3399E660; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.user_video_progress
    ADD CONSTRAINT `PRIMARY_3399E660` PRIMARY KEY (id);


--
-- TOC entry 9217 (class 2606 OID 16758)
-- Name: meeting PRIMARY_3D2EF836; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.meeting
    ADD CONSTRAINT `PRIMARY_3D2EF836` PRIMARY KEY (id);


--
-- TOC entry 9226 (class 2606 OID 16783)
-- Name: banner PRIMARY_4D02B27; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.banner
    ADD CONSTRAINT `PRIMARY_4D02B27` PRIMARY KEY (id);


--
-- TOC entry 9202 (class 2606 OID 16711)
-- Name: user_favorite PRIMARY_5042878B; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.user_favorite
    ADD CONSTRAINT `PRIMARY_5042878B` PRIMARY KEY (id);


--
-- TOC entry 9224 (class 2606 OID 16785)
-- Name: home_intro PRIMARY_54E64707; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.home_intro
    ADD CONSTRAINT `PRIMARY_54E64707` PRIMARY KEY (id);


--
-- TOC entry 9179 (class 2606 OID 16665)
-- Name: user_behavior PRIMARY_5DA34441; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.user_behavior
    ADD CONSTRAINT `PRIMARY_5DA34441` PRIMARY KEY (id);


--
-- TOC entry 9197 (class 2606 OID 16709)
-- Name: course PRIMARY_6F23CE16; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.course
    ADD CONSTRAINT `PRIMARY_6F23CE16` PRIMARY KEY (id);


--
-- TOC entry 9190 (class 2606 OID 16684)
-- Name: meeting_registration PRIMARY_8CD32A38; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.meeting_registration
    ADD CONSTRAINT `PRIMARY_8CD32A38` PRIMARY KEY (id);


--
-- TOC entry 9183 (class 2606 OID 16683)
-- Name: course_enrollment PRIMARY_8D357DA3; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.course_enrollment
    ADD CONSTRAINT `PRIMARY_8D357DA3` PRIMARY KEY (id);


--
-- TOC entry 9222 (class 2606 OID 16760)
-- Name: news PRIMARY_A79808CE; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.news
    ADD CONSTRAINT `PRIMARY_A79808CE` PRIMARY KEY (id);


--
-- TOC entry 9210 (class 2606 OID 16733)
-- Name: tenant PRIMARY_C568D8A5; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.tenant
    ADD CONSTRAINT `PRIMARY_C568D8A5` PRIMARY KEY (id);


--
-- TOC entry 9237 (class 2606 OID 16827)
-- Name: meeting_feedback PRIMARY_CCFA7704; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.meeting_feedback
    ADD CONSTRAINT `PRIMARY_CCFA7704` PRIMARY KEY (id);


--
-- TOC entry 9185 (class 2606 OID 16842)
-- Name: course_enrollment uk_course_user_E8DD661A; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.course_enrollment
    ADD CONSTRAINT `uk_course_user_E8DD661A` UNIQUE (course_id, user_id);


--
-- TOC entry 9192 (class 2606 OID 16863)
-- Name: meeting_registration uk_meeting_user_A274CAFD; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.meeting_registration
    ADD CONSTRAINT `uk_meeting_user_A274CAFD` UNIQUE (meeting_id, user_id);


--
-- TOC entry 9239 (class 2606 OID 16871)
-- Name: meeting_feedback uk_meeting_user_feedback_1E5BB8A9; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.meeting_feedback
    ADD CONSTRAINT `uk_meeting_user_feedback_1E5BB8A9` UNIQUE (meeting_id, user_id);


--
-- TOC entry 9212 (class 2606 OID 16836)
-- Name: tenant uk_tenant_code_EFB0BD9C; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.tenant
    ADD CONSTRAINT `uk_tenant_code_EFB0BD9C` UNIQUE (tenant_code);


--
-- TOC entry 9204 (class 2606 OID 16861)
-- Name: user_favorite uk_user_favorite_D8FD439E; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.user_favorite
    ADD CONSTRAINT `uk_user_favorite_D8FD439E` UNIQUE (user_id, favorite_type, favorite_id);


--
-- TOC entry 9246 (class 2606 OID 16868)
-- Name: user_video_progress uk_user_video_65CA723D; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.user_video_progress
    ADD CONSTRAINT `uk_user_video_65CA723D` UNIQUE (user_id, video_id);


--
-- TOC entry 9208 (class 2606 OID 16833)
-- Name: user uk_username_58B60899; Type: CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.`user`
    ADD CONSTRAINT `uk_username_58B60899` UNIQUE (username);


--
-- TOC entry 9240 (class 1259 OID 16852)
-- Name: fk_user_video_progress_video_A5E94024; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX fk_user_video_progress_video_A5E94024 ON cemenghui_now.user_video_progress USING btree (video_id NULLS FIRST);


--
-- TOC entry 9175 (class 1259 OID 16838)
-- Name: idx_action_type_2B113B57; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_action_type_2B113B57 ON cemenghui_now.user_behavior USING btree (action_type NULLS FIRST);


--
-- TOC entry 9231 (class 1259 OID 16854)
-- Name: idx_arrival_method_78771FCA; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_arrival_method_78771FCA ON cemenghui_now.meeting_feedback USING btree (arrival_method NULLS FIRST);


--
-- TOC entry 9193 (class 1259 OID 16830)
-- Name: idx_author_id_3C09C1E2; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_author_id_3C09C1E2 ON cemenghui_now.course USING btree (author_id NULLS FIRST);


--
-- TOC entry 9218 (class 1259 OID 16831)
-- Name: idx_author_id_F72CB22A; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_author_id_F72CB22A ON cemenghui_now.news USING btree (author_id NULLS FIRST);


--
-- TOC entry 9232 (class 1259 OID 16859)
-- Name: idx_company_name_77B6B56; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_company_name_77B6B56 ON cemenghui_now.meeting_feedback USING btree (company_name NULLS FIRST);


--
-- TOC entry 9227 (class 1259 OID 16850)
-- Name: idx_course_id_4EE8D626; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_course_id_4EE8D626 ON cemenghui_now.course_video USING btree (course_id NULLS FIRST);


--
-- TOC entry 9241 (class 1259 OID 16858)
-- Name: idx_course_id_67FB23D8; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_course_id_67FB23D8 ON cemenghui_now.user_video_progress USING btree (course_id NULLS FIRST);


--
-- TOC entry 9180 (class 1259 OID 16828)
-- Name: idx_course_id_B138B175; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_course_id_B138B175 ON cemenghui_now.course_enrollment USING btree (course_id NULLS FIRST);


--
-- TOC entry 9176 (class 1259 OID 16846)
-- Name: idx_create_time_1C9046F7; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_create_time_1C9046F7 ON cemenghui_now.user_behavior USING btree (create_time NULLS FIRST);


--
-- TOC entry 9219 (class 1259 OID 16839)
-- Name: idx_create_time_6E958E0A; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_create_time_6E958E0A ON cemenghui_now.news USING btree (create_time NULLS FIRST);


--
-- TOC entry 9213 (class 1259 OID 16829)
-- Name: idx_creator_id_A309B826; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_creator_id_A309B826 ON cemenghui_now.meeting USING btree (creator_id NULLS FIRST);


--
-- TOC entry 9198 (class 1259 OID 16844)
-- Name: idx_favorite_id_5894B2AD; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_favorite_id_5894B2AD ON cemenghui_now.user_favorite USING btree (favorite_id NULLS FIRST);


--
-- TOC entry 9199 (class 1259 OID 16849)
-- Name: idx_favorite_type_D1B6644D; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_favorite_type_D1B6644D ON cemenghui_now.user_favorite USING btree (favorite_type NULLS FIRST);


--
-- TOC entry 9233 (class 1259 OID 16864)
-- Name: idx_meeting_id_658150BA; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_meeting_id_658150BA ON cemenghui_now.meeting_feedback USING btree (meeting_id NULLS FIRST);


--
-- TOC entry 9186 (class 1259 OID 16843)
-- Name: idx_meeting_id_CA6D4F06; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_meeting_id_CA6D4F06 ON cemenghui_now.meeting_registration USING btree (meeting_id NULLS FIRST);


--
-- TOC entry 9214 (class 1259 OID 16837)
-- Name: idx_meeting_time_E37A426C; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_meeting_time_E37A426C ON cemenghui_now.meeting USING btree (meeting_time NULLS FIRST);


--
-- TOC entry 9234 (class 1259 OID 16866)
-- Name: idx_rating_BC7F9516; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_rating_BC7F9516 ON cemenghui_now.meeting_feedback USING btree (rating NULLS FIRST);


--
-- TOC entry 9228 (class 1259 OID 16857)
-- Name: idx_sort_order_4B174408; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_sort_order_4B174408 ON cemenghui_now.course_video USING btree (sort_order NULLS FIRST);


--
-- TOC entry 9194 (class 1259 OID 16840)
-- Name: idx_sort_order_870BE2C4; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_sort_order_870BE2C4 ON cemenghui_now.course USING btree (sort_order NULLS FIRST);


--
-- TOC entry 9195 (class 1259 OID 16848)
-- Name: idx_status_1BFFEAEE; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_status_1BFFEAEE ON cemenghui_now.course USING btree (status NULLS FIRST);


--
-- TOC entry 9215 (class 1259 OID 16845)
-- Name: idx_status_69171CCE; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_status_69171CCE ON cemenghui_now.meeting USING btree (status NULLS FIRST);


--
-- TOC entry 9187 (class 1259 OID 16851)
-- Name: idx_status_C379048C; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_status_C379048C ON cemenghui_now.meeting_registration USING btree (status NULLS FIRST);


--
-- TOC entry 9220 (class 1259 OID 16847)
-- Name: idx_status_E70EB136; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_status_E70EB136 ON cemenghui_now.news USING btree (status NULLS FIRST);


--
-- TOC entry 9242 (class 1259 OID 16865)
-- Name: idx_user_course_D5391458; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_user_course_D5391458 ON cemenghui_now.user_video_progress USING btree (user_id NULLS FIRST, course_id NULLS FIRST);


--
-- TOC entry 9188 (class 1259 OID 16856)
-- Name: idx_user_id_3BBB6A40; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_user_id_3BBB6A40 ON cemenghui_now.meeting_registration USING btree (user_id NULLS FIRST);


--
-- TOC entry 9177 (class 1259 OID 16853)
-- Name: idx_user_id_60FD8A57; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_user_id_60FD8A57 ON cemenghui_now.user_behavior USING btree (user_id NULLS FIRST);


--
-- TOC entry 9181 (class 1259 OID 16834)
-- Name: idx_user_id_73F8BF35; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_user_id_73F8BF35 ON cemenghui_now.course_enrollment USING btree (user_id NULLS FIRST);


--
-- TOC entry 9235 (class 1259 OID 16869)
-- Name: idx_user_id_AF8FC2F4; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_user_id_AF8FC2F4 ON cemenghui_now.meeting_feedback USING btree (user_id NULLS FIRST);


--
-- TOC entry 9200 (class 1259 OID 16855)
-- Name: idx_user_id_C7145A4D; Type: INDEX; Schema: cemenghui_now; Owner: system
--

CREATE INDEX idx_user_id_C7145A4D ON cemenghui_now.user_favorite USING btree (user_id NULLS FIRST);


--
-- TOC entry 9247 (class 2606 OID 16872)
-- Name: course_video fk_course_video_course_F70B96C7; Type: FK CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.course_video
    ADD CONSTRAINT `fk_course_video_course_F70B96C7` FOREIGN KEY (course_id) REFERENCES cemenghui_now.course(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 9248 (class 2606 OID 16877)
-- Name: user_video_progress fk_user_video_progress_course_AA18B123; Type: FK CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.user_video_progress
    ADD CONSTRAINT `fk_user_video_progress_course_AA18B123` FOREIGN KEY (course_id) REFERENCES cemenghui_now.course(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 9249 (class 2606 OID 16882)
-- Name: user_video_progress fk_user_video_progress_user_FB85F843; Type: FK CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.user_video_progress
    ADD CONSTRAINT `fk_user_video_progress_user_FB85F843` FOREIGN KEY (user_id) REFERENCES cemenghui_now."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- TOC entry 9250 (class 2606 OID 16887)
-- Name: user_video_progress fk_user_video_progress_video_C90CECC7; Type: FK CONSTRAINT; Schema: cemenghui_now; Owner: system
--

ALTER TABLE ONLY cemenghui_now.user_video_progress
    ADD CONSTRAINT `fk_user_video_progress_video_C90CECC7` FOREIGN KEY (video_id) REFERENCES cemenghui_now.course_video(id) ON UPDATE RESTRICT ON DELETE CASCADE;


-- Completed on 2025-07-05 16:22:03

--
-- Kingbase database dump complete
--

