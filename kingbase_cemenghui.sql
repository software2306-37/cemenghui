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

COMMENT ON TABLE cemenghui.banner IS '�ֲ�ͼ��';


--
-- Name: COLUMN banner.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.id IS '�ֲ�ͼID';


--
-- Name: COLUMN banner.title; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.title IS '����';


--
-- Name: COLUMN banner.image_url; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.image_url IS 'ͼƬURL';


--
-- Name: COLUMN banner.link_url; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.link_url IS '����URL';


--
-- Name: COLUMN banner.sort_order; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.sort_order IS '����';


--
-- Name: COLUMN banner.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.status IS '״̬ 0-���� 1-����';


--
-- Name: COLUMN banner.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.create_time IS '����ʱ��';


--
-- Name: COLUMN banner.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.banner.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.course IS '�γ̱�';


--
-- Name: COLUMN course.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.id IS '�γ�ID';


--
-- Name: COLUMN course.course_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.course_name IS '�γ�����';


--
-- Name: COLUMN course.course_summary; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.course_summary IS '�γ̼��';


--
-- Name: COLUMN course.cover_image; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.cover_image IS '�γ̷���';


--
-- Name: COLUMN course.video_url; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.video_url IS '�γ���Ƶ';


--
-- Name: COLUMN course.author; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.author IS '����';


--
-- Name: COLUMN course.author_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.author_id IS '����ID';


--
-- Name: COLUMN course.sort_order; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.sort_order IS '����';


--
-- Name: COLUMN course.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.status IS '״̬ 0-����� 1-�ѷ��� 2-�Ѿܾ�';


--
-- Name: COLUMN course.audit_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.audit_time IS '���ʱ��';


--
-- Name: COLUMN course.audit_user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.audit_user_id IS '�����ID';


--
-- Name: COLUMN course.view_count; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.view_count IS '�������';


--
-- Name: COLUMN course.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.create_time IS '����ʱ��';


--
-- Name: COLUMN course.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.course_enrollment IS '�γ̱���/ѧϰ��¼��';


--
-- Name: COLUMN course_enrollment.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.id IS 'ID';


--
-- Name: COLUMN course_enrollment.course_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.course_id IS '�γ�ID';


--
-- Name: COLUMN course_enrollment.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.user_id IS '�û�ID';


--
-- Name: COLUMN course_enrollment.user_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.user_name IS '�û�����';


--
-- Name: COLUMN course_enrollment.user_email; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.user_email IS '�û�����';


--
-- Name: COLUMN course_enrollment.user_phone; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.user_phone IS '�û��绰';


--
-- Name: COLUMN course_enrollment.progress; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.progress IS 'ѧϰ���� 0-100';


--
-- Name: COLUMN course_enrollment.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.status IS '״̬ 0:�ѱ��� 1:ѧϰ�� 2:����� 3:��ȡ��';


--
-- Name: COLUMN course_enrollment.enrollment_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.enrollment_time IS '����ʱ��';


--
-- Name: COLUMN course_enrollment.start_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.start_time IS '��ʼѧϰʱ��';


--
-- Name: COLUMN course_enrollment.complete_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.complete_time IS '���ʱ��';


--
-- Name: COLUMN course_enrollment.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.create_time IS '����ʱ��';


--
-- Name: COLUMN course_enrollment.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_enrollment.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.course_video IS '�γ���Ƶ��';


--
-- Name: COLUMN course_video.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.id IS '��ƵID';


--
-- Name: COLUMN course_video.course_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.course_id IS '�γ�ID';


--
-- Name: COLUMN course_video.video_title; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.video_title IS '��Ƶ����';


--
-- Name: COLUMN course_video.video_url; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.video_url IS '��ƵURL';


--
-- Name: COLUMN course_video.video_duration; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.video_duration IS '��Ƶʱ��(��)';


--
-- Name: COLUMN course_video.video_size; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.video_size IS '��Ƶ��С(�ֽ�)';


--
-- Name: COLUMN course_video.video_description; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.video_description IS '��Ƶ����';


--
-- Name: COLUMN course_video.sort_order; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.sort_order IS '�����';


--
-- Name: COLUMN course_video.is_free; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.is_free IS '�Ƿ���� 0-�շ� 1-���';


--
-- Name: COLUMN course_video.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.status IS '״̬ 0-���� 1-����';


--
-- Name: COLUMN course_video.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.create_time IS '����ʱ��';


--
-- Name: COLUMN course_video.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.course_video.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.home_intro IS '��ҳ����';


--
-- Name: COLUMN home_intro.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.id IS 'ID';


--
-- Name: COLUMN home_intro.title; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.title IS '����';


--
-- Name: COLUMN home_intro.content; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.content IS '����';


--
-- Name: COLUMN home_intro.sort_order; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.sort_order IS '����';


--
-- Name: COLUMN home_intro.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.status IS '״̬ 0-���� 1-����';


--
-- Name: COLUMN home_intro.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.create_time IS '����ʱ��';


--
-- Name: COLUMN home_intro.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.home_intro.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.meeting IS '�����';


--
-- Name: COLUMN meeting.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.id IS '����ID';


--
-- Name: COLUMN meeting.meeting_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.meeting_name IS '��������';


--
-- Name: COLUMN meeting.meeting_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.meeting_time IS '����ʱ��';


--
-- Name: COLUMN meeting.meeting_content; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.meeting_content IS '��������';


--
-- Name: COLUMN meeting.cover_image; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.cover_image IS '�������';


--
-- Name: COLUMN meeting.location; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.location IS '����ص�';


--
-- Name: COLUMN meeting.organizer; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.organizer IS '���쵥λ';


--
-- Name: COLUMN meeting.category; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.category IS '�������';


--
-- Name: COLUMN meeting.creator; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.creator IS '������';


--
-- Name: COLUMN meeting.creator_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.creator_id IS '������ID';


--
-- Name: COLUMN meeting.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.status IS '״̬ 0-����� 1-�ѷ��� 2-�Ѿܾ�';


--
-- Name: COLUMN meeting.audit_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.audit_time IS '���ʱ��';


--
-- Name: COLUMN meeting.audit_user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.audit_user_id IS '�����ID';


--
-- Name: COLUMN meeting.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.create_time IS '����ʱ��';


--
-- Name: COLUMN meeting.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.meeting_feedback IS '�λ��ִ��';


--
-- Name: COLUMN meeting_feedback.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.id IS '����ID';


--
-- Name: COLUMN meeting_feedback.meeting_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.meeting_id IS '����ID';


--
-- Name: COLUMN meeting_feedback.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.user_id IS '�û�ID';


--
-- Name: COLUMN meeting_feedback.user_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.user_name IS '�û�����';


--
-- Name: COLUMN meeting_feedback.rating; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.rating IS '��������(1-5��)';


--
-- Name: COLUMN meeting_feedback.content; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.content IS '�λ����';


--
-- Name: COLUMN meeting_feedback.suggestions; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.suggestions IS '�Ľ�����';


--
-- Name: COLUMN meeting_feedback.organization_rating; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.organization_rating IS '��֯����(1-5��)';


--
-- Name: COLUMN meeting_feedback.content_rating; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.content_rating IS '��������(1-5��)';


--
-- Name: COLUMN meeting_feedback.venue_rating; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.venue_rating IS '��������(1-5��)';


--
-- Name: COLUMN meeting_feedback.attachments; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.attachments IS '����·��������ö��ŷָ�';


--
-- Name: COLUMN meeting_feedback.submit_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.submit_time IS '�ύʱ��';


--
-- Name: COLUMN meeting_feedback.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.create_time IS '����ʱ��';


--
-- Name: COLUMN meeting_feedback.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_feedback.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.meeting_registration IS '���鱨����¼��';


--
-- Name: COLUMN meeting_registration.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.id IS '����ID';


--
-- Name: COLUMN meeting_registration.meeting_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.meeting_id IS '����ID';


--
-- Name: COLUMN meeting_registration.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.user_id IS '�û�ID';


--
-- Name: COLUMN meeting_registration.user_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.user_name IS '�û�����';


--
-- Name: COLUMN meeting_registration.user_phone; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.user_phone IS '�û��绰';


--
-- Name: COLUMN meeting_registration.user_email; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.user_email IS '�û�����';


--
-- Name: COLUMN meeting_registration.company_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.company_name IS '��˾����';


--
-- Name: COLUMN meeting_registration.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.status IS '״̬��0-�ѱ�����1-��ǩ����2-����ɣ�3-��ȡ��';


--
-- Name: COLUMN meeting_registration.registration_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.registration_time IS '����ʱ��';


--
-- Name: COLUMN meeting_registration.checkin_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.checkin_time IS 'ǩ��ʱ��';


--
-- Name: COLUMN meeting_registration.remarks; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.remarks IS '��ע';


--
-- Name: COLUMN meeting_registration.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.create_time IS '����ʱ��';


--
-- Name: COLUMN meeting_registration.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.meeting_registration.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.news IS '��ҵ��̬��';


--
-- Name: COLUMN news.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.id IS '��̬ID';


--
-- Name: COLUMN news.title; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.title IS '����';


--
-- Name: COLUMN news.summary; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.summary IS '���';


--
-- Name: COLUMN news.content; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.content IS '����';


--
-- Name: COLUMN news.cover_image; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.cover_image IS '����ͼƬ';


--
-- Name: COLUMN news.author; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.author IS '����';


--
-- Name: COLUMN news.author_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.author_id IS '����ID';


--
-- Name: COLUMN news.category; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.category IS '���ŷ���';


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

COMMENT ON COLUMN cemenghui.news.status IS '״̬ 0-����� 1-�ѷ��� 2-�Ѿܾ�';


--
-- Name: COLUMN news.audit_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.audit_time IS '���ʱ��';


--
-- Name: COLUMN news.audit_user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.audit_user_id IS '�����ID';


--
-- Name: COLUMN news.view_count; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.view_count IS '�������';


--
-- Name: COLUMN news.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.create_time IS '����ʱ��';


--
-- Name: COLUMN news.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.news.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.tenant IS '�⻧��';


--
-- Name: COLUMN tenant.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.id IS '�⻧ID';


--
-- Name: COLUMN tenant.tenant_code; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.tenant_code IS '�⻧��ʶ';


--
-- Name: COLUMN tenant.tenant_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.tenant_name IS '�⻧����';


--
-- Name: COLUMN tenant.contact_person; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.contact_person IS '��ϵ��';


--
-- Name: COLUMN tenant.contact_phone; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.contact_phone IS '��ϵ�绰';


--
-- Name: COLUMN tenant.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.status IS '״̬ 0-���� 1-����';


--
-- Name: COLUMN tenant.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.create_time IS '����ʱ��';


--
-- Name: COLUMN tenant.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.tenant.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.`user` IS '�û���';


--
-- Name: COLUMN `user`.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.id IS '�û�ID';


--
-- Name: COLUMN `user`.username; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.username IS '�û���';


--
-- Name: COLUMN `user`.password; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.password IS '����';


--
-- Name: COLUMN `user`.phone; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.phone IS '�ֻ���';


--
-- Name: COLUMN `user`.email; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.email IS '����';


--
-- Name: COLUMN `user`.nickname; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.nickname IS '�ǳ�';


--
-- Name: COLUMN `user`.gender; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.gender IS '�Ա� 0-δ֪ 1-�� 2-Ů';


--
-- Name: COLUMN `user`.role; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.role IS '��ɫ ADMIN-��������Ա USER-��ҵ�û�';


--
-- Name: COLUMN `user`.status; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.status IS '״̬ 0-���� 1-����';


--
-- Name: COLUMN `user`.avatar; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.avatar IS 'ͷ��';


--
-- Name: COLUMN `user`.company_name; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.company_name IS '��ҵ����';


--
-- Name: COLUMN `user`.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.create_time IS '����ʱ��';


--
-- Name: COLUMN `user`.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.`user`.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.user_behavior IS '�û���Ϊ������';


--
-- Name: COLUMN user_behavior.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.id IS 'ID';


--
-- Name: COLUMN user_behavior.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.user_id IS '�û�ID';


--
-- Name: COLUMN user_behavior.action_type; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.action_type IS '��Ϊ����';


--
-- Name: COLUMN user_behavior.target_type; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.target_type IS 'Ŀ������';


--
-- Name: COLUMN user_behavior.target_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.target_id IS 'Ŀ��ID';


--
-- Name: COLUMN user_behavior.ip_address; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.ip_address IS 'IP��ַ';


--
-- Name: COLUMN user_behavior.user_agent; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.user_agent IS '�û�����';


--
-- Name: COLUMN user_behavior.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_behavior.create_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.user_favorite IS '�û��ղر�';


--
-- Name: COLUMN user_favorite.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.id IS 'ID';


--
-- Name: COLUMN user_favorite.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.user_id IS '�û�ID';


--
-- Name: COLUMN user_favorite.favorite_type; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_type IS '�ղ����� course:�γ� meeting:���� news:����';


--
-- Name: COLUMN user_favorite.favorite_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_id IS '���ղ����ݵ�ID';


--
-- Name: COLUMN user_favorite.favorite_title; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_title IS '���ղ����ݵı���';


--
-- Name: COLUMN user_favorite.favorite_summary; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_summary IS '���ղ����ݵ�ժҪ';


--
-- Name: COLUMN user_favorite.favorite_cover; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_cover IS '���ղ����ݵķ���';


--
-- Name: COLUMN user_favorite.favorite_author; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.favorite_author IS '���ղ����ݵ�����';


--
-- Name: COLUMN user_favorite.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.create_time IS '����ʱ��';


--
-- Name: COLUMN user_favorite.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_favorite.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui.user_video_progress IS '�û���Ƶѧϰ���ȱ�';


--
-- Name: COLUMN user_video_progress.id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.id IS '��¼ID';


--
-- Name: COLUMN user_video_progress.user_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.user_id IS '�û�ID';


--
-- Name: COLUMN user_video_progress.course_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.course_id IS '�γ�ID';


--
-- Name: COLUMN user_video_progress.video_id; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.video_id IS '��ƵID';


--
-- Name: COLUMN user_video_progress.watch_progress; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.watch_progress IS '�ۿ�����(��)';


--
-- Name: COLUMN user_video_progress.watch_percentage; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.watch_percentage IS '�ۿ��ٷֱ�';


--
-- Name: COLUMN user_video_progress.is_completed; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.is_completed IS '�Ƿ���� 0-δ��� 1-�����';


--
-- Name: COLUMN user_video_progress.last_watch_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.last_watch_time IS '���ۿ�ʱ��';


--
-- Name: COLUMN user_video_progress.total_watch_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.total_watch_time IS '�ܹۿ�ʱ��(��)';


--
-- Name: COLUMN user_video_progress.create_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.create_time IS '����ʱ��';


--
-- Name: COLUMN user_video_progress.update_time; Type: COMMENT; Schema: cemenghui; Owner: system
--

COMMENT ON COLUMN cemenghui.user_video_progress.update_time IS '����ʱ��';


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
1	���Լ������2024	/uploads/banner1.jpg	/news/1	1	1	2025-06-22 00:57:07	2025-06-22 00:57:07
2	�Զ������Թ����Ƽ�	/uploads/banner2.jpg	/course/1	2	1	2025-06-22 00:57:07	2025-06-22 00:57:07
3	������ҵ��չ����	/uploads/banner3.jpg	/news/2	3	1	2025-06-22 00:57:07	2025-06-22 00:57:07
4	��ӭ�������˻�	/uploads/banner1.jpg	/pages/about	1	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	���²��Լ�����̬	/uploads/banner2.jpg	/pages/news	2	1	2025-06-22 03:11:04	2025-06-22 03:11:04
6	רҵ�γ���ѵ	/uploads/banner3.jpg	/pages/course	3	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- Data for Name: course; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.course (id, course_name, course_summary, cover_image, video_url, author, author_id, sort_order, status, audit_time, audit_user_id, view_count, create_time, update_time) FROM stdin;
1	������Ի������ſγ�	�ʺ������ѧԱ������������ſγ̣����ǲ������ۡ�������ʵ��	/uploads/b3f37338-d805-4288-a119-a8c35b90e9e8.jpg	/uploads/fbd3931e-ae39-46e3-921a-25c61c8f0606.mp4	��������Ա	1	1	1	\N	\N	467	2025-06-22 03:11:04	2025-06-22 03:11:04
2	Selenium�Զ�������ʵս	ͨ��ʵ����Ŀ����ѧϰSelenium�Զ������Լ���	/uploads/21a8d2ac-2535-46d7-9889-9d3e674dad97.png	/uploads/course2.mp4	��ҵ�û�1	2	2	1	\N	\N	390	2025-06-22 03:11:04	2025-06-22 03:11:04
3	���ܲ��Խ��׿γ�	����ѧϰ���ܲ��Ե����ۺ�ʵ��������JMeter�ȹ��ߵ�ʹ��	/uploads/29389910-ed5a-4870-aa49-25ecbe4e35a8.png	/uploads/course3.mp4	��ҵ�û�2	3	3	1	\N	\N	280	2025-06-22 03:11:04	2025-06-22 03:11:04
4	�ƶ�Ӧ�ò���ר��ѵ��	ר������ƶ�Ӧ�ò��ԵĿγ̣�����Android��iOS���Լ���	/uploads/1eca3f70-6eda-4779-8d0e-cf5f103f3e06.png	/uploads/course4.mp4	��ҵ�û�3	4	4	1	\N	\N	201	2025-06-22 03:11:04	2025-06-22 03:11:04
5	API�ӿڲ���ʵս	ѧϰʹ��Postman��Python�ȹ��߽���API�ӿڲ���	/uploads/ee62e8f1-6c1d-420c-a3bb-182e7772db43.png	/uploads/course5.mp4	��������Ա	1	5	1	\N	\N	358	2025-06-22 03:11:04	2025-06-22 03:11:04
6	���Թ������Ŷӽ���	�����Ŷӹ������������Ż�������������ϵ����	/uploads/618b4471-dfda-40b2-907b-a4e70968a582.png	/uploads/8e3b7ca5-b48a-4fc1-b2d4-d186704d8198.mp4	��ҵ�û�1	2	6	1	2025-06-22 04:54:24	1	174	2025-06-22 03:11:04	2025-06-22 03:46:42
7	1	1			��������Ա	1	0	1	\N	\N	11	2025-06-22 05:15:54	2025-06-22 05:15:54
8	1	1			��������Ա	1	0	1	\N	\N	14	2025-06-22 07:02:29	2025-06-22 07:02:29
9	1	1			��ҵ�û�1	2	0	0	\N	\N	0	2025-06-22 07:08:18	2025-06-22 07:08:18
10	��һ��	��һ��			��������Ա	1	0	1	\N	\N	105	2025-06-24 16:36:49	2025-06-24 17:32:55
\.


--
-- Data for Name: course_enrollment; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.course_enrollment (id, course_id, user_id, user_name, user_email, user_phone, progress, status, enrollment_time, start_time, complete_time, create_time, update_time) FROM stdin;
1	6	9	user3	user3@qq.com	\N	0	0	2025-06-24 15:52:05	\N	\N	2025-06-24 15:52:05	2025-06-24 15:52:05
2	10	12	΢���û�	\N	\N	0	0	2025-06-24 19:25:03	\N	\N	2025-06-24 19:25:03	2025-06-24 19:25:02
\.


--
-- Data for Name: course_video; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.course_video (id, course_id, video_title, video_url, video_duration, video_size, video_description, sort_order, is_free, status, create_time, update_time) FROM stdin;
1	1	��1�£�������Ի�������	/uploads/fbd3931e-ae39-46e3-921a-25c61c8f0606.mp4	1800	0	����������ԵĻ������Ŀ�ĺ���Ҫ��	1	1	1	2025-06-24 16:09:27	2025-06-24 16:09:27
2	1	��2�£����Է��������	/uploads/video1_2.mp4	2100	0	��ϸ����ںв��ԡ��׺в��ԡ��Һв��ԵȲ��Է���	2	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
3	1	��3�£������������	/uploads/video1_3.mp4	2400	0	ѧϰ��������Ч�Ĳ�������	3	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
4	1	��4�£�ȱ�ݹ���	/uploads/video1_4.mp4	1950	0	ȱ�ݵķ��֡���¼�����ٺ͹�������	4	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
5	2	��1�£�Selenium�����	/uploads/video2_1.mp4	1200	0	Selenium WebDriver�������úͻ���ʹ��	1	1	1	2025-06-24 16:09:27	2025-06-24 16:09:27
6	2	��2�£�Ԫ�ض�λ����	/uploads/video2_2.mp4	1800	0	���ո���Ԫ�ض�λ���������ʵ��	2	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
7	2	��3�£�ҳ�����ģʽ	/uploads/video2_3.mp4	2200	0	ѧϰPOM���ģʽ��ߴ����ά����	3	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
8	2	��4�£�������������	/uploads/video2_4.mp4	2000	0	ʵ�������������Զ������Կ��	4	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
9	2	��5�£����Ա�������	/uploads/video2_5.mp4	1500	0	������ϸ�Ĳ��Ա���ͽ������	5	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
10	3	��1�£����ܲ������ۻ���	/uploads/video3_1.mp4	1600	0	���ܲ��ԵĻ������������֪ʶ	1	1	1	2025-06-24 16:09:27	2025-06-24 16:09:27
11	3	��2�£�JMeter����ʹ��	/uploads/video3_2.mp4	2500	0	JMeter���ߵ���ϸʹ�ý̳�	2	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
12	3	��3�£����ܲ��Խű���д	/uploads/video3_3.mp4	2800	0	��д���ӵ����ܲ��Խű�	3	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
13	3	��4�£����ܼ�������	/uploads/video3_4.mp4	2200	0	���ܼ��ָ�������ƿ����λ	4	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
14	4	��1�£��ƶ����Ը���	/uploads/video4_1.mp4	1400	0	�ƶ�Ӧ�ò��Ե��ص����ս	1	1	1	2025-06-24 16:09:27	2025-06-24 16:09:27
15	4	��2�£�Android���Թ���	/uploads/video4_2.mp4	2000	0	AndroidӦ�ò��Թ��ߺͷ���	2	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
16	4	��3�£�iOS����ʵ��	/uploads/video4_3.mp4	1900	0	iOSӦ�ò��Ե�ʵ������	3	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
17	4	��4�£������Բ���	/uploads/video4_4.mp4	2300	0	�ƶ��豸�����Բ��Բ���	4	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
18	5	��1�£�API���Ի���	/uploads/video5_1.mp4	1300	0	API�ӿڲ��ԵĻ���֪ʶ	1	1	1	2025-06-24 16:09:27	2025-06-24 16:09:27
19	5	��2�£�Postmanʵս	/uploads/video5_2.mp4	1700	0	Postman���ߵĸ߼�ʹ�ü���	2	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
20	5	��3�£��Զ����ӿڲ���	/uploads/video5_3.mp4	2100	0	ʹ��Python����API�Զ�������	3	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
21	5	��4�£��ӿڲ��Կ��	/uploads/video5_4.mp4	2400	0	���������Ľӿڲ��Կ��	4	0	1	2025-06-24 16:09:27	2025-06-24 16:09:27
22	10	��һ��	/uploads/29a29236-4a63-467b-b6bf-296070a28e1f.mp4	0	0		1	1	1	2025-06-24 17:32:56	2025-06-24 18:53:11
23	10	�ڶ���	/uploads/a6830d87-d030-4769-82fa-467fdbff428d.mp4	0	0		2	0	1	2025-06-24 17:32:56	2025-06-24 17:32:56
24	10	�ڶ���	/uploads/cd12ba21-5844-4fc9-928c-858396a01f82.mp4	0	0		1	1	1	2025-06-24 17:46:34	2025-06-24 18:53:11
25	10	�ڶ���	/uploads/fa70ce2e-c207-4f06-bb52-82d14697fc89.mp4	0	0		3	0	1	2025-06-24 17:46:34	2025-06-24 17:46:34
27	10	�ڶ���	/uploads/7cb8d65c-bdc9-4490-8bd0-d2462b4fda78.mp4	0	0		2	0	1	2025-06-24 17:59:34	2025-06-24 17:59:34
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
1	���ڲ��˻�	<p>���˻���רҵ�Ĳ�����ҵ����ƽ̨���������ƶ����Լ�����չ...</p>	1	1	2025-06-22 00:57:07	2025-06-22 00:57:07
2	���ǵ�ʹ��	<p>ͨ�������������齻��������������ҵ�Ĳ���ˮƽ...</p>	2	1	2025-06-22 00:57:07	2025-06-22 00:57:07
3	��ϵ����	<p>��ַ�������г�����xxx<br>�绰��400-123-4567<br>���䣺info@cemenghui.com</p>	3	1	2025-06-22 00:57:07	2025-06-22 00:57:07
4	���˻�ƽ̨����	<h2>רҵ�Ĳ��Լ�������ƽ̨</h2><p>���˻�������Ϊ������Դ�ҵ���ṩרҵ�ļ���������ѧϰ�ͺ���ƽ̨�����ǻ������ҵ�ڵ�����ר�Һ���ҵ����ͬ�ƶ����Լ����ķ�չ�ʹ��¡�</p>	1	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	ƽ̨��ɫ����	<h3>? ��������</h3><p>���ڷ������µĲ��Լ������º���ҵ��̬</p><h3>? ���߿γ�</h3><p>�ṩϵͳ���Ĳ��Լ�����ѵ�γ�</p><h3>? ��������</h3><p>��֯������Լ��������������ѵ�</p>	2	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- Data for Name: meeting; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.meeting (id, meeting_name, meeting_time, meeting_content, cover_image, location, organizer, category, creator, creator_id, status, audit_time, audit_user_id, create_time, update_time) FROM stdin;
1	2025��������Լ������	2025-06-25 09:00:00	<h2>������</h2><p>���η�Ὣ��۹�����������������ר��ѧ�ߺ���ҵ��Ӣ����ͬ̽��������Լ��������·�չ���ơ�</p><h2>�������</h2><ul><li>09:00-09:30 ��Ļʽ</li><li>09:30-10:30 �����ݽ���AI�ڲ����е�Ӧ��</li><li>10:30-11:30 Բ�����ۣ������Զ�����δ��</li><li>14:00-15:00 ����������ԭ������ʵ��</li><li>15:00-16:00 ����������������Ŀ���Ծ���</li></ul>	/uploads/9f98ef04-14eb-48fd-ae70-a114b4b8c21d.png	�������ʻ�������	���˻�	�������	��������Ա	1	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
2	�Զ������Թ�����ѵ��	2024-07-20 14:00:00	<h2>��ѵ����</h2><p>Ϊ��������Զ������Թ��������ѵ����������ѧϰ��ʵ�ʲ�����</p><h2>��ѵ����</h2><ul><li>��һ�죺Selenium WebDriver����</li><li>�ڶ��죺�߼����ܺ����ʵ��</li></ul><h2>�ʺ���Ⱥ</h2><p>��һ�����Ի����Ĺ���ʦ</p>	/uploads/8fa76bff-3483-4aaa-b9ea-23b4ca394ae7.png	�Ϻ�������ѵ����	���Լ�������	������ѵ	��ҵ�û�1	2	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
3	���Ա�׼�ƶ����ֻ�	2024-08-10 10:00:00	<h2>��������</h2><p>�����ƶ��µ���ҵ���Ա�׼������������ҵ�Ĳ���������</p><h2>�λ����</h2><ul><li>���Թ���ר��</li><li>�������ϸ�����</li><li>��׼�ƶ�ίԱ���Ա</li></ul>	/uploads/665f774b-262f-42ef-a825-501aeeab51f0.png	���ڻ�չ����	��׼��ίԱ��	��׼�ƶ�	��ҵ�û�2	3	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
4	���ܲ���ʵս������	2024-09-05 13:30:00	<h2>����������</h2><p>ͨ��ʵ�ʰ���ѧϰ���ܲ��Ե��������̡�</p><h2>ѧϰĿ��</h2><ul><li>�������ܲ��Լƻ��ƶ�</li><li>ѧ��ʹ��JMeter����ѹ������</li><li>�������ܲ��Խ��</li></ul>	/uploads/77696977-5b78-4946-9775-2c079cdfa69b.png	�����������ʻ�������	���ܲ���Э��	ʵս������	��ҵ�û�3	4	0	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
5	�ƶ�Ӧ�ò��Խ�����	2024-10-12 15:00:00	<h2>��������</h2><p>�����ƶ�Ӧ�ò��Ե����¼����;��顣</p><h2>���ⰲ��</h2><ul><li>iOS�Զ�������ʵ��</li><li>Android�����Բ���</li><li>�ƶ�Ӧ�������Ż�</li></ul>	/uploads/9caf57fe-182b-4141-abb4-d1d483179642.png	������ӻ�������	�ƶ���������	��������	��������Ա	1	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- Data for Name: meeting_feedback; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.meeting_feedback (id, meeting_id, user_id, user_name, rating, content, suggestions, organization_rating, content_rating, venue_rating, attachments, submit_time, create_time, update_time) FROM stdin;
1	1	9	user3	3	����ͦ�õ�		0	0	0	\N	2025-06-24 15:17:18	2025-06-24 15:17:18	2025-06-24 15:17:17
\.


--
-- Data for Name: meeting_registration; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.meeting_registration (id, meeting_id, user_id, user_name, user_phone, user_email, company_name, status, registration_time, checkin_time, remarks, create_time, update_time) FROM stdin;
1	1	9	user3	\N	user3@qq.com	\N	0	2025-06-24 15:08:54	\N	\N	2025-06-24 15:08:54	2025-06-24 15:08:54
2	1	12	΢���û�	\N	\N	\N	0	2025-06-24 19:26:03	\N	\N	2025-06-24 19:26:03	2025-06-24 19:26:03
3	1	1	��������Ա	13800138000	admin@cemenghui.com	���˻��ܲ�	0	2025-07-01 17:27:29	\N	\N	2025-07-01 17:27:29	2025-07-01 17:27:29
4	2	1	��������Ա	13800138000	admin@cemenghui.com	���˻��ܲ�	0	2025-07-01 17:48:29	\N	\N	2025-07-01 17:48:29	2025-07-01 17:48:29
\.


--
-- Data for Name: news; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.news (id, title, summary, content, cover_image, author, author_id, category, content_images, videos, attachments, status, audit_time, audit_user_id, view_count, create_time, update_time) FROM stdin;
3	���ݿ����еĲ��Բ���	̽�������ݿ�������������ƶ���Ч�Ĳ��Բ���	<h2>���ݲ��Եĺ�������</h2><p>���ݲ���ǿ�����ڽ��롢�������ԡ����ٷ�����</p><h2>�������Ʋ���</h2><p>�����Իǰ�Ƶ��������ڽ׶Σ����������������ƽ׶Ρ�</p><h2>�Զ��������������е�����</h2><p>�Զ������������ݿ����ɹ��Ĺؼ�����֮һ��</p>	/uploads/66ed6f51-571d-4783-b213-9677634573a1.png	��ҵ�û�2	3	��ҵ��̬	\N	\N	\N	1	\N	\N	147	2025-06-22 03:11:04	2025-06-22 21:11:14
5	�ƶ�Ӧ�ò��Լ���Ҫ��	�ƶ�Ӧ�ò��Ե��ص�͹ؼ����������	<h2>�ƶ����Ե���ս</h2><p>�豸��Ƭ�������绷�����ӡ��û�����Ҫ��ߡ�</p><h2>�����Բ���</h2><p>ȷ��Ӧ���ڲ�ͬ�豸��ϵͳ�汾���������С�</p><h2>�����Ż�</h2><p>��עӦ������ʱ�䡢�ڴ�ʹ�á�������ĵ�ָ�ꡣ</p>	/uploads/d05899a8-d07f-4e33-800c-a79cec30e658.png	��ҵ�û�3	4	��ҵ��̬	\N	\N	\N	0	\N	\N	67	2025-06-22 03:11:04	2025-06-22 21:11:14
2	�Զ������Թ�����ȶԱȷ���	��ϸ�Ա��������������Զ������Թ��ߵ���ȱ������ó���1	<h2>Selenium WebDriver</h2><p><strong>�ŵ㣺</strong></p><ul><li>��Դ���</li><li>֧�ֶ��ֱ������</li><li>������Ծ</li></ul><p><strong>ȱ�㣺</strong></p><ul><li>������Ը���</li><li>ִ���ٶȽ���</li></ul><h2>Cypress</h2><p><strong>�ŵ㣺</strong></p><ul><li>����ʹ�ú͵���</li><li>ִ���ٶȿ�</li><li>ʵʱ����</li></ul><p><strong>ȱ�㣺</strong></p><ul><li>��֧��JavaScript</li><li>�����֧������</li></ul>	/uploads/be4f21a2-80b4-4580-90b2-76d67a2b5da0.png	��ҵ�û�1	2	��ҵ��̬	[]	[]	[]	0	\N	\N	193	2025-06-22 03:11:04	2025-06-22 21:11:14
4	���ܲ������ʵ��ָ��	�������ϵͳ���ܲ��Եľ�������ʵ��	<h2>���ܲ��Թ滮</h2><p>�ƶ���ϸ�����ܲ��Լƻ�����ȷ����Ŀ��ͳ�����</p><h2>���Ի���׼��</h2><p>��������������ƵĲ��Ի�����</p><h2>��غͷ���</h2><p>ʵʱ���ϵͳ����ָ�꣬��ʱ��������ƿ����</p>	/uploads/5d6d114e-3fba-4f9e-bdf4-c87386d4c7c6.png	��������Ա	1	��ҵ��̬	\N	\N	\N	1	\N	\N	103	2025-06-22 03:11:04	2025-06-22 21:11:14
1	2025��������Լ�����չ����	����������������ҵ�����·�չ���ƺͼ������	<h2>����</h2><p>����������������Ŀ��ٷ�չ�����Լ���Ҳ�ڲ����ݽ��ʹ��¡����Ľ��������2024��������Լ����ķ�չ���ơ�</p><h2>AI�����Ĳ����Զ���</h2><p>�˹����ܼ����ڲ��������Ӧ��Խ��Խ�㷺���������ܲ����������ɡ��Զ���ȱ�ݼ��ȡ�</p><h2>��ԭ������</h2><p>�����Ƽ��㼼�����ռ�����ԭ�����Գ�Ϊ�µķ�չ����1��</p>	/uploads/2dfe70bd-c805-490e-aa3c-ad4b323ccb83.png	��������Ա	1	��ҵ��̬	[]	[]	[]	1	\N	\N	276	2025-06-22 03:11:04	2025-06-22 21:11:14
\.


--
-- Data for Name: tenant; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.tenant (id, tenant_code, tenant_name, contact_person, contact_phone, status, create_time, update_time) FROM stdin;
1	T001	���ԿƼ����޹�˾	�ž���	13800138001	1	2025-06-22 03:11:04	2025-06-22 03:11:04
2	T002	������Թ�˾	���	13800138002	1	2025-06-22 03:11:04	2025-06-22 03:11:04
3	T003	������������	������	13800138003	1	2025-06-22 03:11:04	2025-06-22 03:11:04
4	T004	�Զ�������ʵ����	�Ծ���	13800138004	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	T005	���ܲ�������	������	13800138005	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: cemenghui; Owner: system
--

COPY cemenghui.`user` (id, username, password, phone, email, nickname, gender, role, status, avatar, company_name, create_time, update_time) FROM stdin;
1	admin	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138000	admin@cemenghui.com	��������Ա	1	ADMIN	1	/uploads/fea83ca4-ee1e-439c-88ed-10ca3c95ac4f.jpeg	���˻��ܲ�	2025-06-22 03:11:04	2025-06-22 03:12:28
3	company2	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138002	company2@test.com	��ҵ�û�2	0	USER	1	\N	������Թ�˾	2025-06-22 03:11:04	2025-06-22 03:12:28
4	company3	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138003	company3@test.com	��ҵ�û�3	0	USER	1	\N	������������	2025-06-22 03:11:04	2025-06-22 03:12:28
5	user1	$2a$10$yMRyuyW0FIqBnPIB2aj/DuudYqIF1erdwYu6W5dEUvybwYIltIp8C	1	1@qq.com	1	2	USER	1	/uploads/4d0bf446-01d6-47d0-bc8c-01bb16a88f3d.jpg	1	2025-06-22 03:12:13	2025-06-22 03:12:13
7	user2	$2a$10$IjyrV3VJzmGoWPg.Bk8Xv.J4WRIPLtoC8dXhDbU6ji4.v3uYhdD4G	\N	484855425@163.com	\N	0	USER	1	\N	\N	2025-06-22 06:08:06	2025-06-22 06:08:06
8	1111	$2a$10$sqwqQwaW016nKyHBE0.KHe1E3MnpZQyhQYHRCMECAGKqmt7GAOEAy	15115151515	15115151515@qq.com	\N	0	USER	1	\N	1	2025-06-22 23:19:30	2025-06-22 23:19:30
9	user3	$2a$10$rgekPmtXa.BS0vaoCG1mX.YiOXpKHPXSFTdRrO3u9wmFyTgNibSRu	\N	user3@qq.com	\N	0	USER	1	\N	\N	2025-06-24 14:24:50	2025-06-24 14:24:50
10	user4	$2a$10$xv1zEWjbqJ.CyVgvFoiPyeeu.n34M/BcqO./fXmozGy0wmbsA0cQ6	\N	user4@163.com	\N	0	USER	1	\N	\N	2025-06-24 14:47:41	2025-06-24 14:47:41
11	wx_1750763401213	wechat_user	\N	99@qq.com	΢���û�	0	USER	1	/uploads/3c80122c-6633-49b6-a8ef-aac4e07cc6e9.jpeg	\N	2025-06-24 19:10:01	2025-06-24 19:10:01
12	wx_1750764285398	wechat_user	\N	\N	΢���û�	0	USER	1	https://thirdwx.qlogo.cn/mmopen/vi_32/POgEwh4mIHO4nibH0KlMECNjjGxQUq24ZEaGT4poC6icRiccVGKSyXwibcPq4BWmiaIGuG1icwxaQX6grC9VemZoJ8rg/132	\N	2025-06-24 19:24:45	2025-06-24 19:24:45
13	wx_1750854404467	wechat_user	\N	\N	΢���û�	0	USER	1	/uploads/6b7c117c-d94b-4abd-8c20-2e7db7c8688f.png	\N	2025-06-25 20:26:44	2025-06-25 20:26:44
14	wx_1750950148526	wechat_user	\N	\N	΢���û�	0	USER	1	https://thirdwx.qlogo.cn/mmopen/vi_32/POgEwh4mIHO4nibH0KlMECNjjGxQUq24ZEaGT4poC6icRiccVGKSyXwibcPq4BWmiaIGuG1icwxaQX6grC9VemZoJ8rg/132	\N	2025-06-26 23:02:29	2025-06-26 23:02:29
2	company1	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138001	company1@test.com	��ҵ�û�1	0	USER	1	/uploads/9480f065-7014-44ac-8301-7d86d6131f78.jpg	���ԿƼ����޹�˾	2025-06-22 03:11:04	2025-06-22 04:03:05
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
5	12	course	10	��һ��	��һ��		��������Ա	2025-06-24 19:26:48	2025-06-24 19:26:47
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

