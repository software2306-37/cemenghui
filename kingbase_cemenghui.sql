--
-- Kingbase database dump
--

-- Dumped from database version 12.1
-- Dumped by sys_dump version 12.1

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
-- Name: cemenghui; Type: SCHEMA; Schema: -; Owner: system
--

CREATE SCHEMA cemenghui;


ALTER SCHEMA cemenghui OWNER TO system;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: banner; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.banner (
    id bigint NOT NULL,
    title character varying(200 char) NOT NULL,
    image_url character varying(255 char) NOT NULL,
    link_url character varying(255 char),
    sort_order integer DEFAULT 0,
    status tinyint DEFAULT 1 NOT NULL,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui.banner OWNER TO system;

--
-- Name: TABLE banner; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.banner IS '轮播图表';


--
-- Name: COLUMN banner.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.id IS '轮播图ID';


--
-- Name: COLUMN banner.title; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.title IS '标题';


--
-- Name: COLUMN banner.image_url; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.image_url IS '图片URL';


--
-- Name: COLUMN banner.link_url; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.link_url IS '链接URL';


--
-- Name: COLUMN banner.sort_order; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.sort_order IS '排序';


--
-- Name: COLUMN banner.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.status IS '状态 0-禁用 1-启用';


--
-- Name: COLUMN banner.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.create_time IS '创建时间';


--
-- Name: COLUMN banner.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.update_time IS '更新时间';


--
-- Name: banner_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.banner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.banner_id_seq OWNER TO system;

--
-- Name: banner_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.banner_id_seq OWNED BY cemenghui.banner.id;


--
-- Name: course; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.course (
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


ALTER TABLE cemenghui.course OWNER TO system;

--
-- Name: TABLE course; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.course IS '课程表';


--
-- Name: COLUMN course.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.id IS '课程ID';


--
-- Name: COLUMN course.course_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.course_name IS '课程名称';


--
-- Name: COLUMN course.course_summary; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.course_summary IS '课程简介';


--
-- Name: COLUMN course.cover_image; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.cover_image IS '课程封面';


--
-- Name: COLUMN course.video_url; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.video_url IS '课程视频';


--
-- Name: COLUMN course.author; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.author IS '作者';


--
-- Name: COLUMN course.author_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.author_id IS '作者ID';


--
-- Name: COLUMN course.sort_order; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.sort_order IS '排序';


--
-- Name: COLUMN course.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.status IS '状态 0-待审核 1-已发布 2-已拒绝';


--
-- Name: COLUMN course.audit_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.audit_time IS '审核时间';


--
-- Name: COLUMN course.audit_user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.audit_user_id IS '审核人ID';


--
-- Name: COLUMN course.view_count; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.view_count IS '浏览次数';


--
-- Name: COLUMN course.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.create_time IS '创建时间';


--
-- Name: COLUMN course.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.update_time IS '更新时间';


--
-- Name: course_enrollment; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.course_enrollment (
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


ALTER TABLE cemenghui.course_enrollment OWNER TO system;

--
-- Name: TABLE course_enrollment; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.course_enrollment IS '课程报名/学习记录表';


--
-- Name: COLUMN course_enrollment.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.id IS 'ID';


--
-- Name: COLUMN course_enrollment.course_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.course_id IS '课程ID';


--
-- Name: COLUMN course_enrollment.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.user_id IS '用户ID';


--
-- Name: COLUMN course_enrollment.user_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.user_name IS '用户姓名';


--
-- Name: COLUMN course_enrollment.user_email; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.user_email IS '用户邮箱';


--
-- Name: COLUMN course_enrollment.user_phone; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.user_phone IS '用户电话';


--
-- Name: COLUMN course_enrollment.progress; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.progress IS '学习进度 0-100';


--
-- Name: COLUMN course_enrollment.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.status IS '状态 0:已报名 1:学习中 2:已完成 3:已取消';


--
-- Name: COLUMN course_enrollment.enrollment_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.enrollment_time IS '报名时间';


--
-- Name: COLUMN course_enrollment.start_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.start_time IS '开始学习时间';


--
-- Name: COLUMN course_enrollment.complete_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.complete_time IS '完成时间';


--
-- Name: COLUMN course_enrollment.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.create_time IS '创建时间';


--
-- Name: COLUMN course_enrollment.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.update_time IS '更新时间';


--
-- Name: course_enrollment_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.course_enrollment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.course_enrollment_id_seq OWNER TO system;

--
-- Name: course_enrollment_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.course_enrollment_id_seq OWNED BY cemenghui.course_enrollment.id;


--
-- Name: course_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.course_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.course_id_seq OWNER TO system;

--
-- Name: course_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.course_id_seq OWNED BY cemenghui.course.id;


--
-- Name: course_video; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.course_video (
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


ALTER TABLE cemenghui.course_video OWNER TO system;

--
-- Name: TABLE course_video; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.course_video IS '课程视频表';


--
-- Name: COLUMN course_video.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.id IS '视频ID';


--
-- Name: COLUMN course_video.course_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.course_id IS '课程ID';


--
-- Name: COLUMN course_video.video_title; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.video_title IS '视频标题';


--
-- Name: COLUMN course_video.video_url; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.video_url IS '视频URL';


--
-- Name: COLUMN course_video.video_duration; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.video_duration IS '视频时长(秒)';


--
-- Name: COLUMN course_video.video_size; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.video_size IS '视频大小(字节)';


--
-- Name: COLUMN course_video.video_description; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.video_description IS '视频描述';


--
-- Name: COLUMN course_video.sort_order; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.sort_order IS '排序号';


--
-- Name: COLUMN course_video.is_free; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.is_free IS '是否免费 0-收费 1-免费';


--
-- Name: COLUMN course_video.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.status IS '状态 0-禁用 1-启用';


--
-- Name: COLUMN course_video.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.create_time IS '创建时间';


--
-- Name: COLUMN course_video.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.update_time IS '更新时间';


--
-- Name: course_video_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.course_video_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.course_video_id_seq OWNER TO system;

--
-- Name: course_video_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.course_video_id_seq OWNED BY cemenghui.course_video.id;


--
-- Name: home_intro; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.home_intro (
    id bigint NOT NULL,
    title character varying(200 char) NOT NULL,
    content text NOT NULL,
    sort_order integer DEFAULT 0,
    status tinyint DEFAULT 1 NOT NULL,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui.home_intro OWNER TO system;

--
-- Name: TABLE home_intro; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.home_intro IS '首页简介表';


--
-- Name: COLUMN home_intro.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.id IS 'ID';


--
-- Name: COLUMN home_intro.title; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.title IS '标题';


--
-- Name: COLUMN home_intro.content; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.content IS '内容';


--
-- Name: COLUMN home_intro.sort_order; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.sort_order IS '排序';


--
-- Name: COLUMN home_intro.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.status IS '状态 0-禁用 1-启用';


--
-- Name: COLUMN home_intro.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.create_time IS '创建时间';


--
-- Name: COLUMN home_intro.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.update_time IS '更新时间';


--
-- Name: home_intro_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.home_intro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.home_intro_id_seq OWNER TO system;

--
-- Name: home_intro_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.home_intro_id_seq OWNED BY cemenghui.home_intro.id;


--
-- Name: meeting; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.meeting (
    id bigint NOT NULL,
    meeting_name character varying(200 char) NOT NULL,
    meeting_time datetime NOT NULL,
    meeting_content text,
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


ALTER TABLE cemenghui.meeting OWNER TO system;

--
-- Name: TABLE meeting; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.meeting IS '会议表';


--
-- Name: COLUMN meeting.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.id IS '会议ID';


--
-- Name: COLUMN meeting.meeting_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.meeting_name IS '会议名称';


--
-- Name: COLUMN meeting.meeting_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.meeting_time IS '会议时间';


--
-- Name: COLUMN meeting.meeting_content; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.meeting_content IS '会议内容';


--
-- Name: COLUMN meeting.cover_image; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.cover_image IS '会议封面';


--
-- Name: COLUMN meeting.location; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.location IS '会议地点';


--
-- Name: COLUMN meeting.organizer; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.organizer IS '主办单位';


--
-- Name: COLUMN meeting.category; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.category IS '会议分类';


--
-- Name: COLUMN meeting.creator; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.creator IS '创建人';


--
-- Name: COLUMN meeting.creator_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.creator_id IS '创建人ID';


--
-- Name: COLUMN meeting.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.status IS '状态 0-待审核 1-已发布 2-已拒绝';


--
-- Name: COLUMN meeting.audit_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.audit_time IS '审核时间';


--
-- Name: COLUMN meeting.audit_user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.audit_user_id IS '审核人ID';


--
-- Name: COLUMN meeting.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.create_time IS '创建时间';


--
-- Name: COLUMN meeting.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.update_time IS '更新时间';


--
-- Name: meeting_feedback; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.meeting_feedback (
    id bigint NOT NULL,
    meeting_id bigint NOT NULL,
    user_id bigint NOT NULL,
    user_name character varying(100 char),
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


ALTER TABLE cemenghui.meeting_feedback OWNER TO system;

--
-- Name: TABLE meeting_feedback; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.meeting_feedback IS '参会回执表';


--
-- Name: COLUMN meeting_feedback.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.id IS '主键ID';


--
-- Name: COLUMN meeting_feedback.meeting_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.meeting_id IS '会议ID';


--
-- Name: COLUMN meeting_feedback.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.user_id IS '用户ID';


--
-- Name: COLUMN meeting_feedback.user_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.user_name IS '用户姓名';


--
-- Name: COLUMN meeting_feedback.rating; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.rating IS '总体评分(1-5分)';


--
-- Name: COLUMN meeting_feedback.content; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.content IS '参会感受';


--
-- Name: COLUMN meeting_feedback.suggestions; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.suggestions IS '改进建议';


--
-- Name: COLUMN meeting_feedback.organization_rating; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.organization_rating IS '组织评分(1-5分)';


--
-- Name: COLUMN meeting_feedback.content_rating; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.content_rating IS '内容评分(1-5分)';


--
-- Name: COLUMN meeting_feedback.venue_rating; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.venue_rating IS '场地评分(1-5分)';


--
-- Name: COLUMN meeting_feedback.attachments; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.attachments IS '附件路径，多个用逗号分隔';


--
-- Name: COLUMN meeting_feedback.submit_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.submit_time IS '提交时间';


--
-- Name: COLUMN meeting_feedback.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.create_time IS '创建时间';


--
-- Name: COLUMN meeting_feedback.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.update_time IS '更新时间';


--
-- Name: meeting_feedback_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.meeting_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.meeting_feedback_id_seq OWNER TO system;

--
-- Name: meeting_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.meeting_feedback_id_seq OWNED BY cemenghui.meeting_feedback.id;


--
-- Name: meeting_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.meeting_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.meeting_id_seq OWNER TO system;

--
-- Name: meeting_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.meeting_id_seq OWNED BY cemenghui.meeting.id;


--
-- Name: meeting_registration; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.meeting_registration (
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


ALTER TABLE cemenghui.meeting_registration OWNER TO system;

--
-- Name: TABLE meeting_registration; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.meeting_registration IS '会议报名记录表';


--
-- Name: COLUMN meeting_registration.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.id IS '主键ID';


--
-- Name: COLUMN meeting_registration.meeting_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.meeting_id IS '会议ID';


--
-- Name: COLUMN meeting_registration.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.user_id IS '用户ID';


--
-- Name: COLUMN meeting_registration.user_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.user_name IS '用户姓名';


--
-- Name: COLUMN meeting_registration.user_phone; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.user_phone IS '用户电话';


--
-- Name: COLUMN meeting_registration.user_email; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.user_email IS '用户邮箱';


--
-- Name: COLUMN meeting_registration.company_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.company_name IS '公司名称';


--
-- Name: COLUMN meeting_registration.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.status IS '状态：0-已报名，1-已签到，2-已完成，3-已取消';


--
-- Name: COLUMN meeting_registration.registration_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.registration_time IS '报名时间';


--
-- Name: COLUMN meeting_registration.checkin_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.checkin_time IS '签到时间';


--
-- Name: COLUMN meeting_registration.remarks; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.remarks IS '备注';


--
-- Name: COLUMN meeting_registration.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.create_time IS '创建时间';


--
-- Name: COLUMN meeting_registration.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.update_time IS '更新时间';


--
-- Name: meeting_registration_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.meeting_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.meeting_registration_id_seq OWNER TO system;

--
-- Name: meeting_registration_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.meeting_registration_id_seq OWNED BY cemenghui.meeting_registration.id;


--
-- Name: news; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.news (
    id bigint NOT NULL,
    title character varying(200 char) NOT NULL,
    summary text,
    content text NOT NULL,
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


ALTER TABLE cemenghui.news OWNER TO system;

--
-- Name: TABLE news; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.news IS '行业动态表';


--
-- Name: COLUMN news.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.id IS '动态ID';


--
-- Name: COLUMN news.title; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.title IS '标题';


--
-- Name: COLUMN news.summary; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.summary IS '简介';


--
-- Name: COLUMN news.content; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.content IS '内容';


--
-- Name: COLUMN news.cover_image; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.cover_image IS '封面图片';


--
-- Name: COLUMN news.author; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.author IS '作者';


--
-- Name: COLUMN news.author_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.author_id IS '作者ID';


--
-- Name: COLUMN news.category; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.category IS '新闻分类';


--
-- Name: COLUMN news.content_images; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.content_images IS '??????URL???(JSON???)';


--
-- Name: COLUMN news.videos; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.videos IS '??????URL???(JSON???)';


--
-- Name: COLUMN news.attachments; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.attachments IS '??????URL???(JSON???)';


--
-- Name: COLUMN news.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.status IS '状态 0-待审核 1-已发布 2-已拒绝';


--
-- Name: COLUMN news.audit_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.audit_time IS '审核时间';


--
-- Name: COLUMN news.audit_user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.audit_user_id IS '审核人ID';


--
-- Name: COLUMN news.view_count; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.view_count IS '浏览次数';


--
-- Name: COLUMN news.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.create_time IS '创建时间';


--
-- Name: COLUMN news.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.update_time IS '更新时间';


--
-- Name: news_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.news_id_seq OWNER TO system;

--
-- Name: news_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.news_id_seq OWNED BY cemenghui.news.id;


--
-- Name: tenant; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.tenant (
    id bigint NOT NULL,
    tenant_code character varying(50 char) NOT NULL,
    tenant_name character varying(100 char) NOT NULL,
    contact_person character varying(50 char) NOT NULL,
    contact_phone character varying(20 char) NOT NULL,
    status tinyint DEFAULT 1 NOT NULL,
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
    update_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui.tenant OWNER TO system;

--
-- Name: TABLE tenant; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.tenant IS '租户表';


--
-- Name: COLUMN tenant.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.id IS '租户ID';


--
-- Name: COLUMN tenant.tenant_code; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.tenant_code IS '租户标识';


--
-- Name: COLUMN tenant.tenant_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.tenant_name IS '租户名称';


--
-- Name: COLUMN tenant.contact_person; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.contact_person IS '联系人';


--
-- Name: COLUMN tenant.contact_phone; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.contact_phone IS '联系电话';


--
-- Name: COLUMN tenant.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.status IS '状态 0-禁用 1-启用';


--
-- Name: COLUMN tenant.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.create_time IS '创建时间';


--
-- Name: COLUMN tenant.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.update_time IS '更新时间';


--
-- Name: tenant_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.tenant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.tenant_id_seq OWNER TO system;

--
-- Name: tenant_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.tenant_id_seq OWNED BY cemenghui.tenant.id;


--
-- Name: user; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.`user` (
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


ALTER TABLE cemenghui.`user` OWNER TO system;

--
-- Name: TABLE `user`; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.`user` IS '用户表';


--
-- Name: COLUMN `user`.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.id IS '用户ID';


--
-- Name: COLUMN `user`.username; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.username IS '用户名';


--
-- Name: COLUMN `user`.password; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.password IS '密码';


--
-- Name: COLUMN `user`.phone; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.phone IS '手机号';


--
-- Name: COLUMN `user`.email; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.email IS '邮箱';


--
-- Name: COLUMN `user`.nickname; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.nickname IS '昵称';


--
-- Name: COLUMN `user`.gender; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.gender IS '性别 0-未知 1-男 2-女';


--
-- Name: COLUMN `user`.role; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.role IS '角色 ADMIN-超级管理员 USER-企业用户';


--
-- Name: COLUMN `user`.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.status IS '状态 0-禁用 1-启用';


--
-- Name: COLUMN `user`.avatar; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.avatar IS '头像';


--
-- Name: COLUMN `user`.company_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.company_name IS '企业名称';


--
-- Name: COLUMN `user`.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.create_time IS '创建时间';


--
-- Name: COLUMN `user`.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.update_time IS '更新时间';


--
-- Name: user_behavior; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.user_behavior (
    id bigint NOT NULL,
    user_id bigint,
    action_type character varying(50 char) NOT NULL,
    target_type character varying(50 char) NOT NULL,
    target_id bigint NOT NULL,
    ip_address character varying(50 char),
    user_agent character varying(500 char),
    create_time datetime DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE cemenghui.user_behavior OWNER TO system;

--
-- Name: TABLE user_behavior; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.user_behavior IS '用户行为分析表';


--
-- Name: COLUMN user_behavior.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.id IS 'ID';


--
-- Name: COLUMN user_behavior.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.user_id IS '用户ID';


--
-- Name: COLUMN user_behavior.action_type; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.action_type IS '行为类型';


--
-- Name: COLUMN user_behavior.target_type; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.target_type IS '目标类型';


--
-- Name: COLUMN user_behavior.target_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.target_id IS '目标ID';


--
-- Name: COLUMN user_behavior.ip_address; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.ip_address IS 'IP地址';


--
-- Name: COLUMN user_behavior.user_agent; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.user_agent IS '用户代理';


--
-- Name: COLUMN user_behavior.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.create_time IS '创建时间';


--
-- Name: user_behavior_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.user_behavior_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.user_behavior_id_seq OWNER TO system;

--
-- Name: user_behavior_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.user_behavior_id_seq OWNED BY cemenghui.user_behavior.id;


--
-- Name: user_favorite; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.user_favorite (
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


ALTER TABLE cemenghui.user_favorite OWNER TO system;

--
-- Name: TABLE user_favorite; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.user_favorite IS '用户收藏表';


--
-- Name: COLUMN user_favorite.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.id IS 'ID';


--
-- Name: COLUMN user_favorite.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.user_id IS '用户ID';


--
-- Name: COLUMN user_favorite.favorite_type; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_type IS '收藏类型 course:课程 meeting:会议 news:新闻';


--
-- Name: COLUMN user_favorite.favorite_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_id IS '被收藏内容的ID';


--
-- Name: COLUMN user_favorite.favorite_title; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_title IS '被收藏内容的标题';


--
-- Name: COLUMN user_favorite.favorite_summary; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_summary IS '被收藏内容的摘要';


--
-- Name: COLUMN user_favorite.favorite_cover; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_cover IS '被收藏内容的封面';


--
-- Name: COLUMN user_favorite.favorite_author; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_author IS '被收藏内容的作者';


--
-- Name: COLUMN user_favorite.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.create_time IS '创建时间';


--
-- Name: COLUMN user_favorite.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.update_time IS '更新时间';


--
-- Name: user_favorite_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.user_favorite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.user_favorite_id_seq OWNER TO system;

--
-- Name: user_favorite_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.user_favorite_id_seq OWNED BY cemenghui.user_favorite.id;


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.user_id_seq OWNER TO system;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.user_id_seq OWNED BY cemenghui.`user`.id;


--
-- Name: user_video_progress; Type: TABLE; Schema: cemenghui; Owner: system
--

CREATE TABLE cemenghui.user_video_progress (
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


ALTER TABLE cemenghui.user_video_progress OWNER TO system;

--
-- Name: TABLE user_video_progress; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON TABLE cemenghui.user_video_progress IS '用户视频学习进度表';


--
-- Name: COLUMN user_video_progress.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.id IS '记录ID';


--
-- Name: COLUMN user_video_progress.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.user_id IS '用户ID';


--
-- Name: COLUMN user_video_progress.course_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.course_id IS '课程ID';


--
-- Name: COLUMN user_video_progress.video_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.video_id IS '视频ID';


--
-- Name: COLUMN user_video_progress.watch_progress; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.watch_progress IS '观看进度(秒)';


--
-- Name: COLUMN user_video_progress.watch_percentage; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.watch_percentage IS '观看百分比';


--
-- Name: COLUMN user_video_progress.is_completed; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.is_completed IS '是否完成 0-未完成 1-已完成';


--
-- Name: COLUMN user_video_progress.last_watch_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.last_watch_time IS '最后观看时间';


--
-- Name: COLUMN user_video_progress.total_watch_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.total_watch_time IS '总观看时长(秒)';


--
-- Name: COLUMN user_video_progress.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.create_time IS '创建时间';


--
-- Name: COLUMN user_video_progress.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.update_time IS '更新时间';


--
-- Name: user_video_progress_id_seq; Type: SEQUENCE; Schema: cemenghui; Owner: system
--

CREATE SEQUENCE cemenghui.user_video_progress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cemenghui.user_video_progress_id_seq OWNER TO system;

--
-- Name: user_video_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: cemenghui; Owner: system
--

ALTER SEQUENCE cemenghui.user_video_progress_id_seq OWNED BY cemenghui.user_video_progress.id;


--
-- Name: banner id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.banner ALTER COLUMN id SET DEFAULT nextval('cemenghui.banner_id_seq'::regclass);


--
-- Name: course id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.course ALTER COLUMN id SET DEFAULT nextval('cemenghui.course_id_seq'::regclass);


--
-- Name: course_enrollment id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.course_enrollment ALTER COLUMN id SET DEFAULT nextval('cemenghui.course_enrollment_id_seq'::regclass);


--
-- Name: course_video id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.course_video ALTER COLUMN id SET DEFAULT nextval('cemenghui.course_video_id_seq'::regclass);


--
-- Name: home_intro id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.home_intro ALTER COLUMN id SET DEFAULT nextval('cemenghui.home_intro_id_seq'::regclass);


--
-- Name: meeting id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.meeting ALTER COLUMN id SET DEFAULT nextval('cemenghui.meeting_id_seq'::regclass);


--
-- Name: meeting_feedback id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.meeting_feedback ALTER COLUMN id SET DEFAULT nextval('cemenghui.meeting_feedback_id_seq'::regclass);


--
-- Name: meeting_registration id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.meeting_registration ALTER COLUMN id SET DEFAULT nextval('cemenghui.meeting_registration_id_seq'::regclass);


--
-- Name: news id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.news ALTER COLUMN id SET DEFAULT nextval('cemenghui.news_id_seq'::regclass);


--
-- Name: tenant id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.tenant ALTER COLUMN id SET DEFAULT nextval('cemenghui.tenant_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.`user` ALTER COLUMN id SET DEFAULT nextval('cemenghui.user_id_seq'::regclass);


--
-- Name: user_behavior id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_behavior ALTER COLUMN id SET DEFAULT nextval('cemenghui.user_behavior_id_seq'::regclass);


--
-- Name: user_favorite id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_favorite ALTER COLUMN id SET DEFAULT nextval('cemenghui.user_favorite_id_seq'::regclass);


--
-- Name: user_video_progress id; Type: DEFAULT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_video_progress ALTER COLUMN id SET DEFAULT nextval('cemenghui.user_video_progress_id_seq'::regclass);


--
-- Data for Name: banner; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.banner (id, title, image_url, link_url, sort_order, status, create_time, update_time) FROM stdin;
1	测试技术大会2024	/uploads/banner1.jpg	/news/1	1	1	2025-06-22 00:57:07	2025-06-22 00:57:07
2	自动化测试工具推荐	/uploads/banner2.jpg	/course/1	2	1	2025-06-22 00:57:07	2025-06-22 00:57:07
3	测试行业发展报告	/uploads/banner3.jpg	/news/2	3	1	2025-06-22 00:57:07	2025-06-22 00:57:07
4	欢迎来到测盟汇	/uploads/banner1.jpg	/pages/about	1	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	最新测试技术动态	/uploads/banner2.jpg	/pages/news	2	1	2025-06-22 03:11:04	2025-06-22 03:11:04
6	专业课程培训	/uploads/banner3.jpg	/pages/course	3	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- Data for Name: course; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.course (id, course_name, course_summary, cover_image, video_url, author, author_id, sort_order, status, audit_time, audit_user_id, view_count, create_time, update_time) FROM stdin;
1	软件测试基础入门课程	适合零基础学员的软件测试入门课程，涵盖测试理论、方法和实践	/uploads/b3f37338-d805-4288-a119-a8c35b90e9e8.jpg	/uploads/fbd3931e-ae39-46e3-921a-25c61c8f0606.mp4	超级管理员	1	1	1	\N	\N	467	2025-06-22 03:11:04	2025-06-22 03:11:04
2	Selenium自动化测试实战	通过实际项目案例学习Selenium自动化测试技术	/uploads/21a8d2ac-2535-46d7-9889-9d3e674dad97.png	/uploads/course2.mp4	企业用户1	2	2	1	\N	\N	390	2025-06-22 03:11:04	2025-06-22 03:11:04
3	性能测试进阶课程	深入学习性能测试的理论和实践，掌握JMeter等工具的使用	/uploads/29389910-ed5a-4870-aa49-25ecbe4e35a8.png	/uploads/course3.mp4	企业用户2	3	3	1	\N	\N	280	2025-06-22 03:11:04	2025-06-22 03:11:04
4	移动应用测试专项训练	专门针对移动应用测试的课程，包含Android和iOS测试技巧	/uploads/1eca3f70-6eda-4779-8d0e-cf5f103f3e06.png	/uploads/course4.mp4	企业用户3	4	4	1	\N	\N	201	2025-06-22 03:11:04	2025-06-22 03:11:04
5	API接口测试实战	学习使用Postman、Python等工具进行API接口测试	/uploads/ee62e8f1-6c1d-420c-a3bb-182e7772db43.png	/uploads/course5.mp4	超级管理员	1	5	1	\N	\N	358	2025-06-22 03:11:04	2025-06-22 03:11:04
6	测试管理与团队建设	测试团队管理、测试流程优化、质量保障体系建设	/uploads/618b4471-dfda-40b2-907b-a4e70968a582.png	/uploads/8e3b7ca5-b48a-4fc1-b2d4-d186704d8198.mp4	企业用户1	2	6	1	2025-06-22 04:54:24	1	174	2025-06-22 03:11:04	2025-06-22 03:46:42
7	1	1			超级管理员	1	0	1	\N	\N	11	2025-06-22 05:15:54	2025-06-22 05:15:54
8	1	1			超级管理员	1	0	1	\N	\N	14	2025-06-22 07:02:29	2025-06-22 07:02:29
9	1	1			企业用户1	2	0	0	\N	\N	0	2025-06-22 07:08:18	2025-06-22 07:08:18
10	第一节	第一节			超级管理员	1	0	1	\N	\N	105	2025-06-24 16:36:49	2025-06-24 17:32:55
\.


--
-- Data for Name: course_enrollment; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.course_enrollment (id, course_id, user_id, user_name, user_email, user_phone, progress, status, enrollment_time, start_time, complete_time, create_time, update_time) FROM stdin;
1	6	9	user3	user3@qq.com	\N	0	0	2025-06-24 15:52:05	\N	\N	2025-06-24 15:52:05	2025-06-24 15:52:05
2	10	12	微信用户	\N	\N	0	0	2025-06-24 19:25:03	\N	\N	2025-06-24 19:25:03	2025-06-24 19:25:02
\.


--
-- Data for Name: course_video; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.course_video (id, course_id, video_title, video_url, video_duration, video_size, video_description, sort_order, is_free, status, create_time, update_time) FROM stdin;
1	1	第1章：软件测试基础概念	/uploads/fbd3931e-ae39-46e3-921a-25c61c8f0606.mp4	1800	0	介绍软件测试的基本概念、目的和重要性	1	1	1	2025-06-24 16:09:27	2025-06-24 16:09:27
2	1	第2章：测试方法与分类	/uploads/video1_2.mp4	2100	0	详细讲解黑盒测试、白盒测试、灰盒测试等测试方法	2	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
3	1	第3章：测试用例设计	/uploads/video1_3.mp4	2400	0	学习如何设计有效的测试用例	3	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
4	1	第4章：缺陷管理	/uploads/video1_4.mp4	1950	0	缺陷的发现、记录、跟踪和管理流程	4	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
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
22	10	第一节	/uploads/29a29236-4a63-467b-b6bf-296070a28e1f.mp4	0	0		1	1	1	2025-06-24 17:32:56	2025-06-24 18:53:11
23	10	第二节	/uploads/a6830d87-d030-4769-82fa-467fdbff428d.mp4	0	0		2	0	1	2025-06-24 17:32:56	2025-06-24 17:32:56
24	10	第二节	/uploads/cd12ba21-5844-4fc9-928c-858396a01f82.mp4	0	0		1	1	1	2025-06-24 17:46:34	2025-06-24 18:53:11
25	10	第二节	/uploads/fa70ce2e-c207-4f06-bb52-82d14697fc89.mp4	0	0		3	0	1	2025-06-24 17:46:34	2025-06-24 17:46:34
27	10	第二节	/uploads/7cb8d65c-bdc9-4490-8bd0-d2462b4fda78.mp4	0	0		2	0	1	2025-06-24 17:59:34	2025-06-24 17:59:34
28	10	1	/uploads/fe6596c9-e89d-4ada-b2b9-cad44a54bedf.mp4	98	0	1	1	0	1	2025-06-24 18:15:26	2025-06-24 18:15:26
29	10	1	/uploads/2ac9ad1c-51d8-41e8-9d50-237adb40b41a.mp4	98	0	1	5	0	1	2025-06-24 18:16:42	2025-06-24 18:16:42
30	10	3	/uploads/58afda89-24e3-4f2f-bae1-83391a32357c.mp4	98	0	3	1	0	1	2025-06-24 18:46:04	2025-06-24 18:46:04
31	10	2	/uploads/3fe592a2-8f9d-4c27-aa7e-4f5f015267c6.mp4	98	0	2	4	0	1	2025-06-24 18:47:14	2025-06-24 18:47:14
32	10	1	/uploads/d92b96fc-d7b7-4a0f-bb9b-ddfae1861bef.mp4	40	0	1	1	1	1	2025-06-24 18:53:11	2025-06-24 18:53:11
\.


--
-- Data for Name: home_intro; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.home_intro (id, title, content, sort_order, status, create_time, update_time) FROM stdin;
1	关于测盟汇	<p>测盟汇是专业的测试行业交流平台，致力于推动测试技术发展...</p>	1	1	2025-06-22 00:57:07	2025-06-22 00:57:07
2	我们的使命	<p>通过技术分享、经验交流，提升整个行业的测试水平...</p>	2	1	2025-06-22 00:57:07	2025-06-22 00:57:07
3	联系我们	<p>地址：北京市朝阳区xxx<br>电话：400-123-4567<br>邮箱：info@cemenghui.com</p>	3	1	2025-06-22 00:57:07	2025-06-22 00:57:07
4	测盟汇平台介绍	<h2>专业的测试技术交流平台</h2><p>测盟汇致力于为软件测试从业者提供专业的技术交流、学习和合作平台。我们汇聚了行业内的优秀专家和企业，共同推动测试技术的发展和创新。</p>	1	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	平台特色服务	<h3>? 技术分享</h3><p>定期发布最新的测试技术文章和行业动态</p><h3>? 在线课程</h3><p>提供系统化的测试技术培训课程</p><h3>? 合作会议</h3><p>组织各类测试技术交流会议和培训活动</p>	2	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- Data for Name: meeting; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.meeting (id, meeting_name, meeting_time, meeting_content, cover_image, location, organizer, category, creator, creator_id, status, audit_time, audit_user_id, create_time, update_time) FROM stdin;
1	2025年软件测试技术峰会	2025-06-25 09:00:00	<h2>会议简介</h2><p>本次峰会将汇聚国内外软件测试领域的专家学者和行业精英，共同探讨软件测试技术的最新发展趋势。</p><h2>会议议程</h2><ul><li>09:00-09:30 开幕式</li><li>09:30-10:30 主题演讲：AI在测试中的应用</li><li>10:30-11:30 圆桌讨论：测试自动化的未来</li><li>14:00-15:00 技术分享：云原生测试实践</li><li>15:00-16:00 案例分析：大型项目测试经验</li></ul>	/uploads/9f98ef04-14eb-48fd-ae70-a114b4b8c21d.png	北京国际会议中心	测盟汇	技术峰会	超级管理员	1	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
2	自动化测试工具培训班	2024-07-20 14:00:00	<h2>培训内容</h2><p>为期两天的自动化测试工具深度培训，包括理论学习和实际操作。</p><h2>培训安排</h2><ul><li>第一天：Selenium WebDriver基础</li><li>第二天：高级功能和最佳实践</li></ul><h2>适合人群</h2><p>有一定测试基础的工程师</p>	/uploads/8fa76bff-3483-4aaa-b9ea-23b4ca394ae7.png	上海技术培训中心	测试技术联盟	技术培训	企业用户1	2	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
3	测试标准制定研讨会	2024-08-10 10:00:00	<h2>研讨主题</h2><p>讨论制定新的行业测试标准，提升整个行业的测试质量。</p><h2>参会对象</h2><ul><li>测试管理专家</li><li>质量保障负责人</li><li>标准制定委员会成员</li></ul>	/uploads/665f774b-262f-42ef-a825-501aeeab51f0.png	深圳会展中心	标准化委员会	标准制定	企业用户2	3	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
4	性能测试实战工作坊	2024-09-05 13:30:00	<h2>工作坊内容</h2><p>通过实际案例学习性能测试的完整流程。</p><h2>学习目标</h2><ul><li>掌握性能测试计划制定</li><li>学会使用JMeter进行压力测试</li><li>分析性能测试结果</li></ul>	/uploads/77696977-5b78-4946-9775-2c079cdfa69b.png	杭州西湖国际会议中心	性能测试协会	实战工作坊	企业用户3	4	0	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
5	移动应用测试交流会	2024-10-12 15:00:00	<h2>交流内容</h2><p>分享移动应用测试的最新技术和经验。</p><h2>议题安排</h2><ul><li>iOS自动化测试实践</li><li>Android兼容性测试</li><li>移动应用性能优化</li></ul>	/uploads/9caf57fe-182b-4141-abb4-d1d483179642.png	广州天河会议中心	移动测试联盟	技术交流	超级管理员	1	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- Data for Name: meeting_feedback; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.meeting_feedback (id, meeting_id, user_id, user_name, rating, content, suggestions, organization_rating, content_rating, venue_rating, attachments, submit_time, create_time, update_time) FROM stdin;
1	1	9	user3	3	会议挺好的		0	0	0	\N	2025-06-24 15:17:18	2025-06-24 15:17:18	2025-06-24 15:17:17
\.


--
-- Data for Name: meeting_registration; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.meeting_registration (id, meeting_id, user_id, user_name, user_phone, user_email, company_name, status, registration_time, checkin_time, remarks, create_time, update_time) FROM stdin;
1	1	9	user3	\N	user3@qq.com	\N	0	2025-06-24 15:08:54	\N	\N	2025-06-24 15:08:54	2025-06-24 15:08:54
2	1	12	微信用户	\N	\N	\N	0	2025-06-24 19:26:03	\N	\N	2025-06-24 19:26:03	2025-06-24 19:26:03
3	1	1	超级管理员	13800138000	admin@cemenghui.com	测盟汇总部	0	2025-07-01 17:27:29	\N	\N	2025-07-01 17:27:29	2025-07-01 17:27:29
4	2	1	超级管理员	13800138000	admin@cemenghui.com	测盟汇总部	0	2025-07-01 17:48:29	\N	\N	2025-07-01 17:48:29	2025-07-01 17:48:29
\.


--
-- Data for Name: news; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.news (id, title, summary, content, cover_image, author, author_id, category, content_images, videos, attachments, status, audit_time, audit_user_id, view_count, create_time, update_time) FROM stdin;
3	敏捷开发中的测试策略	探讨在敏捷开发环境下如何制定有效的测试策略	<h2>敏捷测试的核心理念</h2><p>敏捷测试强调早期介入、持续测试、快速反馈。</p><h2>测试左移策略</h2><p>将测试活动前移到开发早期阶段，包括需求分析、设计阶段。</p><h2>自动化测试在敏捷中的作用</h2><p>自动化测试是敏捷开发成功的关键因素之一。</p>	/uploads/66ed6f51-571d-4783-b213-9677634573a1.png	企业用户2	3	行业动态	\N	\N	\N	1	\N	\N	147	2025-06-22 03:11:04	2025-06-22 21:11:14
5	移动应用测试技术要点	移动应用测试的特点和关键技术点分析	<h2>移动测试的挑战</h2><p>设备碎片化、网络环境复杂、用户体验要求高。</p><h2>兼容性测试</h2><p>确保应用在不同设备和系统版本上正常运行。</p><h2>性能优化</h2><p>关注应用启动时间、内存使用、电池消耗等指标。</p>	/uploads/d05899a8-d07f-4e33-800c-a79cec30e658.png	企业用户3	4	行业动态	\N	\N	\N	0	\N	\N	67	2025-06-22 03:11:04	2025-06-22 21:11:14
2	自动化测试工具深度对比分析	详细对比市面上主流的自动化测试工具的优缺点和适用场景1	<h2>Selenium WebDriver</h2><p><strong>优点：</strong></p><ul><li>开源免费</li><li>支持多种编程语言</li><li>社区活跃</li></ul><p><strong>缺点：</strong></p><ul><li>配置相对复杂</li><li>执行速度较慢</li></ul><h2>Cypress</h2><p><strong>优点：</strong></p><ul><li>易于使用和调试</li><li>执行速度快</li><li>实时重载</li></ul><p><strong>缺点：</strong></p><ul><li>仅支持JavaScript</li><li>浏览器支持有限</li></ul>	/uploads/be4f21a2-80b4-4580-90b2-76d67a2b5da0.png	企业用户1	2	行业动态	[]	[]	[]	0	\N	\N	193	2025-06-22 03:11:04	2025-06-22 21:11:14
4	性能测试最佳实践指南	分享大型系统性能测试的经验和最佳实践	<h2>性能测试规划</h2><p>制定详细的性能测试计划，明确测试目标和场景。</p><h2>测试环境准备</h2><p>搭建与生产环境相似的测试环境。</p><h2>监控和分析</h2><p>实时监控系统性能指标，及时发现性能瓶颈。</p>	/uploads/5d6d114e-3fba-4f9e-bdf4-c87386d4c7c6.png	超级管理员	1	行业动态	\N	\N	\N	1	\N	\N	103	2025-06-22 03:11:04	2025-06-22 21:11:14
1	2025年软件测试技术发展趋势	深入分析软件测试行业的最新发展趋势和技术变革	<h2>引言</h2><p>随着软件开发技术的快速发展，测试技术也在不断演进和创新。本文将深入分析2024年软件测试技术的发展趋势。</p><h2>AI驱动的测试自动化</h2><p>人工智能技术在测试领域的应用越来越广泛，包括智能测试用例生成、自动化缺陷检测等。</p><h2>云原生测试</h2><p>随着云计算技术的普及，云原生测试成为新的发展方向1。</p>	/uploads/2dfe70bd-c805-490e-aa3c-ad4b323ccb83.png	超级管理员	1	行业动态	[]	[]	[]	1	\N	\N	276	2025-06-22 03:11:04	2025-06-22 21:11:14
\.


--
-- Data for Name: tenant; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.tenant (id, tenant_code, tenant_name, contact_person, contact_phone, status, create_time, update_time) FROM stdin;
1	T001	测试科技有限公司	张经理	13800138001	1	2025-06-22 03:11:04	2025-06-22 03:11:04
2	T002	软件测试公司	李经理	13800138002	1	2025-06-22 03:11:04	2025-06-22 03:11:04
3	T003	质量保障中心	王经理	13800138003	1	2025-06-22 03:11:04	2025-06-22 03:11:04
4	T004	自动化测试实验室	赵经理	13800138004	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	T005	性能测试中心	刘经理	13800138005	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.`user` (id, username, password, phone, email, nickname, gender, role, status, avatar, company_name, create_time, update_time) FROM stdin;
1	admin	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138000	admin@cemenghui.com	超级管理员	1	ADMIN	1	/uploads/fea83ca4-ee1e-439c-88ed-10ca3c95ac4f.jpeg	测盟汇总部	2025-06-22 03:11:04	2025-06-22 03:12:28
3	company2	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138002	company2@test.com	企业用户2	0	USER	1	\N	软件测试公司	2025-06-22 03:11:04	2025-06-22 03:12:28
4	company3	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138003	company3@test.com	企业用户3	0	USER	1	\N	质量保障中心	2025-06-22 03:11:04	2025-06-22 03:12:28
5	user1	$2a$10$yMRyuyW0FIqBnPIB2aj/DuudYqIF1erdwYu6W5dEUvybwYIltIp8C	1	1@qq.com	1	2	USER	1	/uploads/4d0bf446-01d6-47d0-bc8c-01bb16a88f3d.jpg	1	2025-06-22 03:12:13	2025-06-22 03:12:13
7	user2	$2a$10$IjyrV3VJzmGoWPg.Bk8Xv.J4WRIPLtoC8dXhDbU6ji4.v3uYhdD4G	\N	484855425@163.com	\N	0	USER	1	\N	\N	2025-06-22 06:08:06	2025-06-22 06:08:06
8	1111	$2a$10$sqwqQwaW016nKyHBE0.KHe1E3MnpZQyhQYHRCMECAGKqmt7GAOEAy	15115151515	15115151515@qq.com	\N	0	USER	1	\N	1	2025-06-22 23:19:30	2025-06-22 23:19:30
9	user3	$2a$10$rgekPmtXa.BS0vaoCG1mX.YiOXpKHPXSFTdRrO3u9wmFyTgNibSRu	\N	user3@qq.com	\N	0	USER	1	\N	\N	2025-06-24 14:24:50	2025-06-24 14:24:50
10	user4	$2a$10$xv1zEWjbqJ.CyVgvFoiPyeeu.n34M/BcqO./fXmozGy0wmbsA0cQ6	\N	user4@163.com	\N	0	USER	1	\N	\N	2025-06-24 14:47:41	2025-06-24 14:47:41
11	wx_1750763401213	wechat_user	\N	99@qq.com	微信用户	0	USER	1	/uploads/3c80122c-6633-49b6-a8ef-aac4e07cc6e9.jpeg	\N	2025-06-24 19:10:01	2025-06-24 19:10:01
12	wx_1750764285398	wechat_user	\N	\N	微信用户	0	USER	1	https://thirdwx.qlogo.cn/mmopen/vi_32/POgEwh4mIHO4nibH0KlMECNjjGxQUq24ZEaGT4poC6icRiccVGKSyXwibcPq4BWmiaIGuG1icwxaQX6grC9VemZoJ8rg/132	\N	2025-06-24 19:24:45	2025-06-24 19:24:45
13	wx_1750854404467	wechat_user	\N	\N	微信用户	0	USER	1	/uploads/6b7c117c-d94b-4abd-8c20-2e7db7c8688f.png	\N	2025-06-25 20:26:44	2025-06-25 20:26:44
14	wx_1750950148526	wechat_user	\N	\N	微信用户	0	USER	1	https://thirdwx.qlogo.cn/mmopen/vi_32/POgEwh4mIHO4nibH0KlMECNjjGxQUq24ZEaGT4poC6icRiccVGKSyXwibcPq4BWmiaIGuG1icwxaQX6grC9VemZoJ8rg/132	\N	2025-06-26 23:02:29	2025-06-26 23:02:29
2	company1	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138001	company1@test.com	企业用户1	0	USER	1	/uploads/9480f065-7014-44ac-8301-7d86d6131f78.jpg	测试科技有限公司	2025-06-22 03:11:04	2025-06-22 04:03:05
\.


--
-- Data for Name: user_behavior; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.user_behavior (id, user_id, action_type, target_type, target_id, ip_address, user_agent, create_time) FROM stdin;
1	2	VIEW	NEWS	1	192.168.1.100	\N	2025-06-22 03:11:04
2	3	VIEW	COURSE	1	192.168.1.101	\N	2025-06-22 03:11:04
3	4	REGISTER	MEETING	1	192.168.1.102	\N	2025-06-22 03:11:04
4	2	VIEW	NEWS	2	192.168.1.100	\N	2025-06-22 03:11:04
5	3	VIEW	COURSE	2	192.168.1.101	\N	2025-06-22 03:11:04
\.


--
-- Data for Name: user_favorite; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.user_favorite (id, user_id, favorite_type, favorite_id, favorite_title, favorite_summary, favorite_cover, favorite_author, create_time, update_time) FROM stdin;
5	12	course	10	第一节	第一节		超级管理员	2025-06-24 19:26:48	2025-06-24 19:26:47
\.


--
-- Data for Name: user_video_progress; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.user_video_progress (id, user_id, course_id, video_id, watch_progress, watch_percentage, is_completed, last_watch_time, total_watch_time, create_time, update_time) FROM stdin;
1	9	10	22	86	0.00	0	2025-06-24 18:44:37	-793442670	2025-06-24 17:54:58	2025-06-24 18:44:37
2	9	10	24	8	0.00	0	2025-06-24 18:44:29	1053	2025-06-24 17:55:03	2025-06-24 18:44:29
4	9	3	10	0	0.00	0	2025-06-24 18:15:31	66	2025-06-24 18:15:31	2025-06-24 18:15:31
5	9	10	32	24	60.00	0	2025-06-24 18:54:58	24	2025-06-24 18:54:33	2025-06-24 18:54:58
6	12	10	22	5	0.00	0	2025-06-24 19:25:16	6	2025-06-24 19:25:10	2025-06-24 19:25:16
7	13	10	32	8	20.00	0	2025-06-25 20:27:12	8	2025-06-25 20:27:03	2025-06-25 20:27:12
8	14	10	22	4	0.00	0	2025-06-26 23:02:52	11	2025-06-26 23:02:45	2025-06-26 23:02:52
9	14	1	1	0	0.00	0	2025-06-26 23:03:28	1750950208	2025-06-26 23:03:28	2025-06-26 23:03:28
\.


--
-- Name: banner_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.banner_id_seq', 6, false);


--
-- Name: course_enrollment_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.course_enrollment_id_seq', 3, false);


--
-- Name: course_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.course_id_seq', 11, true);


--
-- Name: course_video_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.course_video_id_seq', 33, false);


--
-- Name: home_intro_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.home_intro_id_seq', 5, false);


--
-- Name: meeting_feedback_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.meeting_feedback_id_seq', 1, false);


--
-- Name: meeting_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.meeting_id_seq', 7, false);


--
-- Name: meeting_registration_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.meeting_registration_id_seq', 4, true);


--
-- Name: news_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.news_id_seq', 12, true);


--
-- Name: tenant_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.tenant_id_seq', 7, false);


--
-- Name: user_behavior_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.user_behavior_id_seq', 5, false);


--
-- Name: user_favorite_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.user_favorite_id_seq', 6, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.user_id_seq', 15, true);


--
-- Name: user_video_progress_id_seq; Type: SEQUENCE SET; Schema: cemenghui; Owner: system
--

SELECT pg_catalog.setval('cemenghui.user_video_progress_id_seq', 9, false);


--
-- Name: user PRIMARY_196A79C6; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.`user`
    ADD CONSTRAINT `PRIMARY_196A79C6` PRIMARY KEY (id);


--
-- Name: course_video PRIMARY_24128D52; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.course_video
    ADD CONSTRAINT `PRIMARY_24128D52` PRIMARY KEY (id);


--
-- Name: user_video_progress PRIMARY_3399E660; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_video_progress
    ADD CONSTRAINT `PRIMARY_3399E660` PRIMARY KEY (id);


--
-- Name: meeting PRIMARY_3D2EF836; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.meeting
    ADD CONSTRAINT `PRIMARY_3D2EF836` PRIMARY KEY (id);


--
-- Name: banner PRIMARY_4D02B27; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.banner
    ADD CONSTRAINT `PRIMARY_4D02B27` PRIMARY KEY (id);


--
-- Name: user_favorite PRIMARY_5042878B; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_favorite
    ADD CONSTRAINT `PRIMARY_5042878B` PRIMARY KEY (id);


--
-- Name: home_intro PRIMARY_54E64707; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.home_intro
    ADD CONSTRAINT `PRIMARY_54E64707` PRIMARY KEY (id);


--
-- Name: user_behavior PRIMARY_5DA34441; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_behavior
    ADD CONSTRAINT `PRIMARY_5DA34441` PRIMARY KEY (id);


--
-- Name: course PRIMARY_6F23CE16; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.course
    ADD CONSTRAINT `PRIMARY_6F23CE16` PRIMARY KEY (id);


--
-- Name: meeting_registration PRIMARY_8CD32A38; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.meeting_registration
    ADD CONSTRAINT `PRIMARY_8CD32A38` PRIMARY KEY (id);


--
-- Name: course_enrollment PRIMARY_8D357DA3; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.course_enrollment
    ADD CONSTRAINT `PRIMARY_8D357DA3` PRIMARY KEY (id);


--
-- Name: news PRIMARY_A79808CE; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.news
    ADD CONSTRAINT `PRIMARY_A79808CE` PRIMARY KEY (id);


--
-- Name: tenant PRIMARY_C568D8A5; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.tenant
    ADD CONSTRAINT `PRIMARY_C568D8A5` PRIMARY KEY (id);


--
-- Name: meeting_feedback PRIMARY_CCFA7704; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.meeting_feedback
    ADD CONSTRAINT `PRIMARY_CCFA7704` PRIMARY KEY (id);


--
-- Name: course_enrollment uk_course_user_E8DD661A; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.course_enrollment
    ADD CONSTRAINT `uk_course_user_E8DD661A` UNIQUE (course_id, user_id);


--
-- Name: meeting_registration uk_meeting_user_A274CAFD; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.meeting_registration
    ADD CONSTRAINT `uk_meeting_user_A274CAFD` UNIQUE (meeting_id, user_id);


--
-- Name: meeting_feedback uk_meeting_user_feedback_1E5BB8A9; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.meeting_feedback
    ADD CONSTRAINT `uk_meeting_user_feedback_1E5BB8A9` UNIQUE (meeting_id, user_id);


--
-- Name: tenant uk_tenant_code_EFB0BD9C; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.tenant
    ADD CONSTRAINT `uk_tenant_code_EFB0BD9C` UNIQUE (tenant_code);


--
-- Name: user_favorite uk_user_favorite_D8FD439E; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_favorite
    ADD CONSTRAINT `uk_user_favorite_D8FD439E` UNIQUE (user_id, favorite_type, favorite_id);


--
-- Name: user_video_progress uk_user_video_65CA723D; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_video_progress
    ADD CONSTRAINT `uk_user_video_65CA723D` UNIQUE (user_id, video_id);


--
-- Name: user uk_username_58B60899; Type: CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.`user`
    ADD CONSTRAINT `uk_username_58B60899` UNIQUE (username);


--
-- Name: fk_user_video_progress_video_A5E94024; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX fk_user_video_progress_video_A5E94024 ON cemenghui.user_video_progress USING btree (video_id NULLS FIRST);


--
-- Name: idx_action_type_2B113B57; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_action_type_2B113B57 ON cemenghui.user_behavior USING btree (action_type NULLS FIRST);


--
-- Name: idx_author_id_3C09C1E2; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_author_id_3C09C1E2 ON cemenghui.course USING btree (author_id NULLS FIRST);


--
-- Name: idx_author_id_F72CB22A; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_author_id_F72CB22A ON cemenghui.news USING btree (author_id NULLS FIRST);


--
-- Name: idx_course_id_4EE8D626; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_course_id_4EE8D626 ON cemenghui.course_video USING btree (course_id NULLS FIRST);


--
-- Name: idx_course_id_67FB23D8; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_course_id_67FB23D8 ON cemenghui.user_video_progress USING btree (course_id NULLS FIRST);


--
-- Name: idx_course_id_B138B175; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_course_id_B138B175 ON cemenghui.course_enrollment USING btree (course_id NULLS FIRST);


--
-- Name: idx_create_time_1C9046F7; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_create_time_1C9046F7 ON cemenghui.user_behavior USING btree (create_time NULLS FIRST);


--
-- Name: idx_create_time_6E958E0A; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_create_time_6E958E0A ON cemenghui.news USING btree (create_time NULLS FIRST);


--
-- Name: idx_creator_id_A309B826; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_creator_id_A309B826 ON cemenghui.meeting USING btree (creator_id NULLS FIRST);


--
-- Name: idx_favorite_id_5894B2AD; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_favorite_id_5894B2AD ON cemenghui.user_favorite USING btree (favorite_id NULLS FIRST);


--
-- Name: idx_favorite_type_D1B6644D; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_favorite_type_D1B6644D ON cemenghui.user_favorite USING btree (favorite_type NULLS FIRST);


--
-- Name: idx_meeting_id_658150BA; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_meeting_id_658150BA ON cemenghui.meeting_feedback USING btree (meeting_id NULLS FIRST);


--
-- Name: idx_meeting_id_CA6D4F06; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_meeting_id_CA6D4F06 ON cemenghui.meeting_registration USING btree (meeting_id NULLS FIRST);


--
-- Name: idx_meeting_time_E37A426C; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_meeting_time_E37A426C ON cemenghui.meeting USING btree (meeting_time NULLS FIRST);


--
-- Name: idx_rating_BC7F9516; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_rating_BC7F9516 ON cemenghui.meeting_feedback USING btree (rating NULLS FIRST);


--
-- Name: idx_sort_order_4B174408; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_sort_order_4B174408 ON cemenghui.course_video USING btree (sort_order NULLS FIRST);


--
-- Name: idx_sort_order_870BE2C4; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_sort_order_870BE2C4 ON cemenghui.course USING btree (sort_order NULLS FIRST);


--
-- Name: idx_status_1BFFEAEE; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_status_1BFFEAEE ON cemenghui.course USING btree (status NULLS FIRST);


--
-- Name: idx_status_69171CCE; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_status_69171CCE ON cemenghui.meeting USING btree (status NULLS FIRST);


--
-- Name: idx_status_C379048C; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_status_C379048C ON cemenghui.meeting_registration USING btree (status NULLS FIRST);


--
-- Name: idx_status_E70EB136; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_status_E70EB136 ON cemenghui.news USING btree (status NULLS FIRST);


--
-- Name: idx_user_course_D5391458; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_user_course_D5391458 ON cemenghui.user_video_progress USING btree (user_id NULLS FIRST, course_id NULLS FIRST);


--
-- Name: idx_user_id_3BBB6A40; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_user_id_3BBB6A40 ON cemenghui.meeting_registration USING btree (user_id NULLS FIRST);


--
-- Name: idx_user_id_60FD8A57; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_user_id_60FD8A57 ON cemenghui.user_behavior USING btree (user_id NULLS FIRST);


--
-- Name: idx_user_id_73F8BF35; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_user_id_73F8BF35 ON cemenghui.course_enrollment USING btree (user_id NULLS FIRST);


--
-- Name: idx_user_id_AF8FC2F4; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_user_id_AF8FC2F4 ON cemenghui.meeting_feedback USING btree (user_id NULLS FIRST);


--
-- Name: idx_user_id_C7145A4D; Type: INDEX; Schema: cemenghui; Owner: system
--

CREATE INDEX idx_user_id_C7145A4D ON cemenghui.user_favorite USING btree (user_id NULLS FIRST);


--
-- Name: course_video fk_course_video_course_F70B96C7; Type: FK CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.course_video
    ADD CONSTRAINT `fk_course_video_course_F70B96C7` FOREIGN KEY (course_id) REFERENCES cemenghui.course(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: user_video_progress fk_user_video_progress_course_AA18B123; Type: FK CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_video_progress
    ADD CONSTRAINT `fk_user_video_progress_course_AA18B123` FOREIGN KEY (course_id) REFERENCES cemenghui.course(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: user_video_progress fk_user_video_progress_user_FB85F843; Type: FK CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_video_progress
    ADD CONSTRAINT `fk_user_video_progress_user_FB85F843` FOREIGN KEY (user_id) REFERENCES cemenghui."user"(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: user_video_progress fk_user_video_progress_video_C90CECC7; Type: FK CONSTRAINT; Schema: cemenghui; Owner: system
--

ALTER TABLE ONLY cemenghui.user_video_progress
    ADD CONSTRAINT `fk_user_video_progress_video_C90CECC7` FOREIGN KEY (video_id) REFERENCES cemenghui.course_video(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Kingbase database dump complete
--

