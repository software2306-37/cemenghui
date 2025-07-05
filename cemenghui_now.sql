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

COMMENT ON TABLE cemenghui_now.banner IS '�ֲ�ͼ��';


--
-- TOC entry 9725 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.id IS '�ֲ�ͼID';


--
-- TOC entry 9726 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.title; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.title IS '����';


--
-- TOC entry 9727 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.image_url; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.image_url IS 'ͼƬURL';


--
-- TOC entry 9728 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.link_url; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.link_url IS '����URL';


--
-- TOC entry 9729 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.sort_order; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.sort_order IS '����';


--
-- TOC entry 9730 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.status IS '״̬ 0-���� 1-����';


--
-- TOC entry 9731 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.create_time IS '����ʱ��';


--
-- TOC entry 9732 (class 0 OID 0)
-- Dependencies: 610
-- Name: COLUMN banner.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.banner.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.course IS '�γ̱�';


--
-- TOC entry 9734 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.id IS '�γ�ID';


--
-- TOC entry 9735 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.course_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.course_name IS '�γ�����';


--
-- TOC entry 9736 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.course_summary; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.course_summary IS '�γ̼��';


--
-- TOC entry 9737 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.cover_image; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.cover_image IS '�γ̷���';


--
-- TOC entry 9738 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.video_url; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.video_url IS '�γ���Ƶ';


--
-- TOC entry 9739 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.author; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.author IS '����';


--
-- TOC entry 9740 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.author_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.author_id IS '����ID';


--
-- TOC entry 9741 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.sort_order; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.sort_order IS '����';


--
-- TOC entry 9742 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.status IS '״̬ 0-����� 1-�ѷ��� 2-�Ѿܾ�';


--
-- TOC entry 9743 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.audit_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.audit_time IS '���ʱ��';


--
-- TOC entry 9744 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.audit_user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.audit_user_id IS '�����ID';


--
-- TOC entry 9745 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.view_count; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.view_count IS '�������';


--
-- TOC entry 9746 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.create_time IS '����ʱ��';


--
-- TOC entry 9747 (class 0 OID 0)
-- Dependencies: 596
-- Name: COLUMN course.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.course_enrollment IS '�γ̱���/ѧϰ��¼��';


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

COMMENT ON COLUMN cemenghui_now.course_enrollment.course_id IS '�γ�ID';


--
-- TOC entry 9751 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.user_id IS '�û�ID';


--
-- TOC entry 9752 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.user_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.user_name IS '�û�����';


--
-- TOC entry 9753 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.user_email; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.user_email IS '�û�����';


--
-- TOC entry 9754 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.user_phone; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.user_phone IS '�û��绰';


--
-- TOC entry 9755 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.progress; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.progress IS 'ѧϰ���� 0-100';


--
-- TOC entry 9756 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.status IS '״̬ 0:�ѱ��� 1:ѧϰ�� 2:����� 3:��ȡ��';


--
-- TOC entry 9757 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.enrollment_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.enrollment_time IS '����ʱ��';


--
-- TOC entry 9758 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.start_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.start_time IS '��ʼѧϰʱ��';


--
-- TOC entry 9759 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.complete_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.complete_time IS '���ʱ��';


--
-- TOC entry 9760 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.create_time IS '����ʱ��';


--
-- TOC entry 9761 (class 0 OID 0)
-- Dependencies: 592
-- Name: COLUMN course_enrollment.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_enrollment.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.course_video IS '�γ���Ƶ��';


--
-- TOC entry 9763 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.id IS '��ƵID';


--
-- TOC entry 9764 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.course_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.course_id IS '�γ�ID';


--
-- TOC entry 9765 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.video_title; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.video_title IS '��Ƶ����';


--
-- TOC entry 9766 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.video_url; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.video_url IS '��ƵURL';


--
-- TOC entry 9767 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.video_duration; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.video_duration IS '��Ƶʱ��(��)';


--
-- TOC entry 9768 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.video_size; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.video_size IS '��Ƶ��С(�ֽ�)';


--
-- TOC entry 9769 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.video_description; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.video_description IS '��Ƶ����';


--
-- TOC entry 9770 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.sort_order; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.sort_order IS '�����';


--
-- TOC entry 9771 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.is_free; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.is_free IS '�Ƿ���� 0-�շ� 1-���';


--
-- TOC entry 9772 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.status IS '״̬ 0-���� 1-����';


--
-- TOC entry 9773 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.create_time IS '����ʱ��';


--
-- TOC entry 9774 (class 0 OID 0)
-- Dependencies: 612
-- Name: COLUMN course_video.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.course_video.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.home_intro IS '��ҳ����';


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

COMMENT ON COLUMN cemenghui_now.home_intro.title IS '����';


--
-- TOC entry 9778 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.content; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.content IS '����';


--
-- TOC entry 9779 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.sort_order; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.sort_order IS '����';


--
-- TOC entry 9780 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.status IS '״̬ 0-���� 1-����';


--
-- TOC entry 9781 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.create_time IS '����ʱ��';


--
-- TOC entry 9782 (class 0 OID 0)
-- Dependencies: 608
-- Name: COLUMN home_intro.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.home_intro.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.meeting IS '�����';


--
-- TOC entry 9784 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.id IS '����ID';


--
-- TOC entry 9785 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.meeting_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.meeting_name IS '��������';


--
-- TOC entry 9786 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.meeting_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.meeting_time IS '����ʱ��';


--
-- TOC entry 9787 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.meeting_content; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.meeting_content IS '��������';


--
-- TOC entry 9788 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.cover_image; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.cover_image IS '�������';


--
-- TOC entry 9789 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.location; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.location IS '����ص�';


--
-- TOC entry 9790 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.organizer; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.organizer IS '���쵥λ';


--
-- TOC entry 9791 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.category; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.category IS '�������';


--
-- TOC entry 9792 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.creator; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.creator IS '������';


--
-- TOC entry 9793 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.creator_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.creator_id IS '������ID';


--
-- TOC entry 9794 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.status IS '״̬ 0-����� 1-�ѷ��� 2-�Ѿܾ�';


--
-- TOC entry 9795 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.audit_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.audit_time IS '���ʱ��';


--
-- TOC entry 9796 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.audit_user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.audit_user_id IS '�����ID';


--
-- TOC entry 9797 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.create_time IS '����ʱ��';


--
-- TOC entry 9798 (class 0 OID 0)
-- Dependencies: 604
-- Name: COLUMN meeting.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.meeting_feedback IS '�λ��ִ��';


--
-- TOC entry 9800 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.id IS '����ID';


--
-- TOC entry 9801 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.meeting_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.meeting_id IS '����ID';


--
-- TOC entry 9802 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.user_id IS '�û�ID';


--
-- TOC entry 9803 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.user_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.user_name IS '�û�����';


--
-- TOC entry 9804 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.company_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.company_name IS '��λ����';


--
-- TOC entry 9805 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.gender; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.gender IS '�Ա�';


--
-- TOC entry 9806 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.user_phone; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.user_phone IS '�ֻ�����';


--
-- TOC entry 9807 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.user_email; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.user_email IS '��������';


--
-- TOC entry 9808 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.arrival_method; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.arrival_method IS '���﷽ʽ';


--
-- TOC entry 9809 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.arrival_info; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.arrival_info IS '���ﳵ��/����';


--
-- TOC entry 9810 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.arrival_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.arrival_time IS '����ʱ��';


--
-- TOC entry 9811 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.rating; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.rating IS '��������(1-5��)';


--
-- TOC entry 9812 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.content; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.content IS '�λ����';


--
-- TOC entry 9813 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.suggestions; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.suggestions IS '�Ľ�����';


--
-- TOC entry 9814 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.organization_rating; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.organization_rating IS '��֯����(1-5��)';


--
-- TOC entry 9815 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.content_rating; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.content_rating IS '��������(1-5��)';


--
-- TOC entry 9816 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.venue_rating; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.venue_rating IS '��������(1-5��)';


--
-- TOC entry 9817 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.attachments; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.attachments IS '����·��������ö��ŷָ�';


--
-- TOC entry 9818 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.submit_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.submit_time IS '�ύʱ��';


--
-- TOC entry 9819 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.create_time IS '����ʱ��';


--
-- TOC entry 9820 (class 0 OID 0)
-- Dependencies: 614
-- Name: COLUMN meeting_feedback.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_feedback.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.meeting_registration IS '���鱨����¼��';


--
-- TOC entry 9822 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.id IS '����ID';


--
-- TOC entry 9823 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.meeting_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.meeting_id IS '����ID';


--
-- TOC entry 9824 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.user_id IS '�û�ID';


--
-- TOC entry 9825 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.user_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.user_name IS '�û�����';


--
-- TOC entry 9826 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.user_phone; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.user_phone IS '�û��绰';


--
-- TOC entry 9827 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.user_email; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.user_email IS '�û�����';


--
-- TOC entry 9828 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.company_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.company_name IS '��˾����';


--
-- TOC entry 9829 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.status IS '״̬��0-�ѱ�����1-��ǩ����2-����ɣ�3-��ȡ��';


--
-- TOC entry 9830 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.registration_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.registration_time IS '����ʱ��';


--
-- TOC entry 9831 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.checkin_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.checkin_time IS 'ǩ��ʱ��';


--
-- TOC entry 9832 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.remarks; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.remarks IS '��ע';


--
-- TOC entry 9833 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.create_time IS '����ʱ��';


--
-- TOC entry 9834 (class 0 OID 0)
-- Dependencies: 594
-- Name: COLUMN meeting_registration.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.meeting_registration.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.news IS '��ҵ��̬��';


--
-- TOC entry 9836 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.id IS '��̬ID';


--
-- TOC entry 9837 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.title; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.title IS '����';


--
-- TOC entry 9838 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.summary; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.summary IS '���';


--
-- TOC entry 9839 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.content; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.content IS '����';


--
-- TOC entry 9840 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.cover_image; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.cover_image IS '����ͼƬ';


--
-- TOC entry 9841 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.author; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.author IS '����';


--
-- TOC entry 9842 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.author_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.author_id IS '����ID';


--
-- TOC entry 9843 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.category; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.category IS '���ŷ���';


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

COMMENT ON COLUMN cemenghui_now.news.status IS '״̬ 0-����� 1-�ѷ��� 2-�Ѿܾ�';


--
-- TOC entry 9848 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.audit_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.audit_time IS '���ʱ��';


--
-- TOC entry 9849 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.audit_user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.audit_user_id IS '�����ID';


--
-- TOC entry 9850 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.view_count; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.view_count IS '�������';


--
-- TOC entry 9851 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.create_time IS '����ʱ��';


--
-- TOC entry 9852 (class 0 OID 0)
-- Dependencies: 606
-- Name: COLUMN news.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.news.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.tenant IS '�⻧��';


--
-- TOC entry 9854 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.id IS '�⻧ID';


--
-- TOC entry 9855 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.tenant_code; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.tenant_code IS '�⻧��ʶ';


--
-- TOC entry 9856 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.tenant_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.tenant_name IS '�⻧����';


--
-- TOC entry 9857 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.contact_person; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.contact_person IS '��ϵ��';


--
-- TOC entry 9858 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.contact_phone; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.contact_phone IS '��ϵ�绰';


--
-- TOC entry 9859 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.status IS '״̬ 0-���� 1-����';


--
-- TOC entry 9860 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.create_time IS '����ʱ��';


--
-- TOC entry 9861 (class 0 OID 0)
-- Dependencies: 602
-- Name: COLUMN tenant.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.tenant.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.`user` IS '�û���';


--
-- TOC entry 9863 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.id IS '�û�ID';


--
-- TOC entry 9864 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.username; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.username IS '�û���';


--
-- TOC entry 9865 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.password; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.password IS '����';


--
-- TOC entry 9866 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.phone; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.phone IS '�ֻ���';


--
-- TOC entry 9867 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.email; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.email IS '����';


--
-- TOC entry 9868 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.nickname; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.nickname IS '�ǳ�';


--
-- TOC entry 9869 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.gender; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.gender IS '�Ա� 0-δ֪ 1-�� 2-Ů';


--
-- TOC entry 9870 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.role; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.role IS '��ɫ ADMIN-��������Ա USER-��ҵ�û�';


--
-- TOC entry 9871 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.status; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.status IS '״̬ 0-���� 1-����';


--
-- TOC entry 9872 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.avatar; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.avatar IS 'ͷ��';


--
-- TOC entry 9873 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.company_name; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.company_name IS '��ҵ����';


--
-- TOC entry 9874 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.create_time IS '����ʱ��';


--
-- TOC entry 9875 (class 0 OID 0)
-- Dependencies: 600
-- Name: COLUMN `user`.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.`user`.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.user_behavior IS '�û���Ϊ������';


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

COMMENT ON COLUMN cemenghui_now.user_behavior.user_id IS '�û�ID';


--
-- TOC entry 9879 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.action_type; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.action_type IS '��Ϊ����';


--
-- TOC entry 9880 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.target_type; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.target_type IS 'Ŀ������';


--
-- TOC entry 9881 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.target_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.target_id IS 'Ŀ��ID';


--
-- TOC entry 9882 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.ip_address; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.ip_address IS 'IP��ַ';


--
-- TOC entry 9883 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.user_agent; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.user_agent IS '�û�����';


--
-- TOC entry 9884 (class 0 OID 0)
-- Dependencies: 591
-- Name: COLUMN user_behavior.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_behavior.create_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.user_favorite IS '�û��ղر�';


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

COMMENT ON COLUMN cemenghui_now.user_favorite.user_id IS '�û�ID';


--
-- TOC entry 9888 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_type; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_type IS '�ղ����� course:�γ� meeting:���� news:����';


--
-- TOC entry 9889 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_id IS '���ղ����ݵ�ID';


--
-- TOC entry 9890 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_title; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_title IS '���ղ����ݵı���';


--
-- TOC entry 9891 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_summary; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_summary IS '���ղ����ݵ�ժҪ';


--
-- TOC entry 9892 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_cover; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_cover IS '���ղ����ݵķ���';


--
-- TOC entry 9893 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.favorite_author; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.favorite_author IS '���ղ����ݵ�����';


--
-- TOC entry 9894 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.create_time IS '����ʱ��';


--
-- TOC entry 9895 (class 0 OID 0)
-- Dependencies: 598
-- Name: COLUMN user_favorite.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_favorite.update_time IS '����ʱ��';


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

COMMENT ON TABLE cemenghui_now.user_video_progress IS '�û���Ƶѧϰ���ȱ�';


--
-- TOC entry 9897 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.id IS '��¼ID';


--
-- TOC entry 9898 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.user_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.user_id IS '�û�ID';


--
-- TOC entry 9899 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.course_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.course_id IS '�γ�ID';


--
-- TOC entry 9900 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.video_id; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.video_id IS '��ƵID';


--
-- TOC entry 9901 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.watch_progress; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.watch_progress IS '�ۿ�����(��)';


--
-- TOC entry 9902 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.watch_percentage; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.watch_percentage IS '�ۿ��ٷֱ�';


--
-- TOC entry 9903 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.is_completed; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.is_completed IS '�Ƿ���� 0-δ��� 1-�����';


--
-- TOC entry 9904 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.last_watch_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.last_watch_time IS '���ۿ�ʱ��';


--
-- TOC entry 9905 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.total_watch_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.total_watch_time IS '�ܹۿ�ʱ��(��)';


--
-- TOC entry 9906 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.create_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.create_time IS '����ʱ��';


--
-- TOC entry 9907 (class 0 OID 0)
-- Dependencies: 616
-- Name: COLUMN user_video_progress.update_time; Type: COMMENT; Schema: cemenghui_now; Owner: system
--

COMMENT ON COLUMN cemenghui_now.user_video_progress.update_time IS '����ʱ��';


--
-- TOC entry 9711 (class 0 OID 16775)
-- Dependencies: 610
-- Data for Name: banner; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.banner (id, title, image_url, link_url, sort_order, status, create_time, update_time) FROM stdin;
1	���Լ������2024	/uploads/banner1.jpg	/news/1	1	1	2025-06-22 00:57:07	2025-06-22 00:57:07
2	�Զ������Թ����Ƽ�	/uploads/banner2.jpg	/course/1	2	1	2025-06-22 00:57:07	2025-06-22 00:57:07
3	������ҵ��չ����	/uploads/banner3.jpg	/news/2	3	1	2025-06-22 00:57:07	2025-06-22 00:57:07
4	��ӭ�������˻�	/uploads/banner1.jpg	/pages/about	1	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	���²��Լ�����̬	/uploads/banner2.jpg	/pages/news	2	1	2025-06-22 03:11:04	2025-06-22 03:11:04
6	רҵ�γ���ѵ	/uploads/banner3.jpg	/pages/course	3	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- TOC entry 9697 (class 0 OID 16687)
-- Dependencies: 596
-- Data for Name: course; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.course (id, course_name, course_summary, cover_image, video_url, author, author_id, sort_order, status, audit_time, audit_user_id, view_count, create_time, update_time) FROM stdin;
1	������Ի������ſγ�	�ʺ������ѧԱ������������ſγ̣����ǲ������ۡ�������ʵ��	/uploads/bb4c7878-0cff-43c5-8379-88bb9e62904b.png	/uploads/fbd3931e-ae39-46e3-921a-25c61c8f0606.mp4	��������Ա	1	1	1	\N	\N	464	2025-06-22 03:11:04	2025-07-04 15:21:03
2	Selenium�Զ�������ʵս	ͨ��ʵ����Ŀ����ѧϰSelenium�Զ������Լ���	/uploads/21a8d2ac-2535-46d7-9889-9d3e674dad97.png	/uploads/course2.mp4	��ҵ�û�1	2	2	1	\N	\N	390	2025-06-22 03:11:04	2025-06-22 03:11:04
3	���ܲ��Խ��׿γ�	����ѧϰ���ܲ��Ե����ۺ�ʵ��������JMeter�ȹ��ߵ�ʹ��	/uploads/29389910-ed5a-4870-aa49-25ecbe4e35a8.png	/uploads/course3.mp4	��ҵ�û�2	3	3	1	\N	\N	280	2025-06-22 03:11:04	2025-06-22 03:11:04
4	�ƶ�Ӧ�ò���ר��ѵ��	ר������ƶ�Ӧ�ò��ԵĿγ̣�����Android��iOS���Լ���	/uploads/1eca3f70-6eda-4779-8d0e-cf5f103f3e06.png	/uploads/course4.mp4	��ҵ�û�3	4	4	1	\N	\N	203	2025-06-22 03:11:04	2025-06-22 03:11:04
9	1	1			��ҵ�û�1	2	0	0	\N	\N	4	2025-06-22 07:08:18	2025-06-22 07:08:18
6	���Թ������Ŷӽ���	�����Ŷӹ������������Ż�������������ϵ����	/uploads/618b4471-dfda-40b2-907b-a4e70968a582.png	/uploads/8e3b7ca5-b48a-4fc1-b2d4-d186704d8198.mp4	��ҵ�û�1	2	6	1	2025-06-22 04:54:24	1	176	2025-06-22 03:11:04	2025-06-22 03:46:42
5	API�ӿڲ���ʵս	ѧϰʹ��Postman��Python�ȹ��߽���API�ӿڲ���	/uploads/ee62e8f1-6c1d-420c-a3bb-182e7772db43.png	/uploads/course5.mp4	��������Ա	1	5	1	\N	\N	366	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- TOC entry 9693 (class 0 OID 16661)
-- Dependencies: 592
-- Data for Name: course_enrollment; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.course_enrollment (id, course_id, user_id, user_name, user_email, user_phone, progress, status, enrollment_time, start_time, complete_time, create_time, update_time) FROM stdin;
1	6	9	user3	user3@qq.com	\N	0	0	2025-06-24 15:52:05	\N	\N	2025-06-24 15:52:05	2025-06-24 15:52:05
2	10	12	΢���û�	\N	\N	0	0	2025-06-24 19:25:03	\N	\N	2025-06-24 19:25:03	2025-06-24 19:25:02
\.


--
-- TOC entry 9713 (class 0 OID 16788)
-- Dependencies: 612
-- Data for Name: course_video; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.course_video (id, course_id, video_title, video_url, video_duration, video_size, video_description, sort_order, is_free, status, create_time, update_time) FROM stdin;
1	1	��1�£�������Ի�������	/uploads/fbd3931e-ae39-46e3-921a-25c61c8f0606.mp4	1800	0	����������ԵĻ������Ŀ�ĺ���Ҫ��	1	1	1	2025-06-24 16:09:27	2025-07-04 15:21:04
2	1	��2�£����Է��������	/uploads/video1_2.mp4	2100	0	��ϸ����ںв��ԡ��׺в��ԡ��Һв��ԵȲ��Է���	2	0	1	2025-06-24 16:09:27	2025-07-04 15:21:04
3	1	��3�£������������	/uploads/video1_3.mp4	2400	0	ѧϰ��������Ч�Ĳ�������	3	0	1	2025-06-24 16:09:27	2025-07-04 15:21:04
4	1	��4�£�ȱ�ݹ���	/uploads/video1_4.mp4	1950	0	ȱ�ݵķ��֡���¼�����ٺ͹�������	4	0	1	2025-06-24 16:09:27	2025-07-04 15:21:04
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
\.


--
-- TOC entry 9709 (class 0 OID 16763)
-- Dependencies: 608
-- Data for Name: home_intro; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.home_intro (id, title, content, sort_order, status, create_time, update_time) FROM stdin;
1	���ڲ��˻�	<p>���˻���רҵ�Ĳ�����ҵ����ƽ̨���������ƶ����Լ�����չ...</p>	1	1	2025-06-22 00:57:07	2025-06-22 00:57:07
2	���ǵ�ʹ��	<p>ͨ�������������齻��������������ҵ�Ĳ���ˮƽ...</p>	2	1	2025-06-22 00:57:07	2025-06-22 00:57:07
3	��ϵ����	<p>��ַ�������г�����xxx<br>�绰��400-123-4567<br>���䣺info@cemenghui.com</p>	3	1	2025-06-22 00:57:07	2025-06-22 00:57:07
4	���˻�ƽ̨����	<h2>רҵ�Ĳ��Լ�������ƽ̨</h2><p>���˻�������Ϊ������Դ�ҵ���ṩרҵ�ļ���������ѧϰ�ͺ���ƽ̨�����ǻ������ҵ�ڵ�����ר�Һ���ҵ����ͬ�ƶ����Լ����ķ�չ�ʹ��¡�</p>	1	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	ƽ̨��ɫ����	<h3>? ��������</h3><p>���ڷ������µĲ��Լ������º���ҵ��̬</p><h3>? ���߿γ�</h3><p>�ṩϵͳ���Ĳ��Լ�����ѵ�γ�</p><h3>? ��������</h3><p>��֯������Լ��������������ѵ�</p>	2	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- TOC entry 9705 (class 0 OID 16736)
-- Dependencies: 604
-- Data for Name: meeting; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.meeting (id, meeting_name, meeting_time, meeting_content, cover_image, location, organizer, category, creator, creator_id, status, audit_time, audit_user_id, create_time, update_time) FROM stdin;
1	2025��������Լ������	2025-06-25 09:00:00	<h2>������</h2><p>���η�Ὣ��۹�����������������ר��ѧ�ߺ���ҵ��Ӣ����ͬ̽��������Լ��������·�չ���ơ�</p><h2>�������</h2><ul><li>09:00-09:30 ��Ļʽ</li><li>09:30-10:30 �����ݽ���AI�ڲ����е�Ӧ��</li><li>10:30-11:30 Բ�����ۣ������Զ�����δ��</li><li>14:00-15:00 ����������ԭ������ʵ��</li><li>15:00-16:00 ����������������Ŀ���Ծ���</li></ul>	/uploads/9f98ef04-14eb-48fd-ae70-a114b4b8c21d.png	�������ʻ�������	���˻�	�������	��������Ա	1	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
2	�Զ������Թ�����ѵ��	2024-07-20 14:00:00	<h2>��ѵ����</h2><p>Ϊ��������Զ������Թ��������ѵ����������ѧϰ��ʵ�ʲ�����</p><h2>��ѵ����</h2><ul><li>��һ�죺Selenium WebDriver����</li><li>�ڶ��죺�߼����ܺ����ʵ��</li></ul><h2>�ʺ���Ⱥ</h2><p>��һ�����Ի����Ĺ���ʦ</p>	/uploads/8fa76bff-3483-4aaa-b9ea-23b4ca394ae7.png	�Ϻ�������ѵ����	���Լ�������	������ѵ	��ҵ�û�1	2	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
3	���Ա�׼�ƶ����ֻ�	2024-08-10 10:00:00	<h2>��������</h2><p>�����ƶ��µ���ҵ���Ա�׼������������ҵ�Ĳ���������</p><h2>�λ����</h2><ul><li>���Թ���ר��</li><li>�������ϸ�����</li><li>��׼�ƶ�ίԱ���Ա</li></ul>	/uploads/665f774b-262f-42ef-a825-501aeeab51f0.png	���ڻ�չ����	��׼��ίԱ��	��׼�ƶ�	��ҵ�û�2	3	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
4	���ܲ���ʵս������	2024-09-05 13:30:00	<h2>����������</h2><p>ͨ��ʵ�ʰ���ѧϰ���ܲ��Ե��������̡�</p><h2>ѧϰĿ��</h2><ul><li>�������ܲ��Լƻ��ƶ�</li><li>ѧ��ʹ��JMeter����ѹ������</li><li>�������ܲ��Խ��</li></ul>	/uploads/77696977-5b78-4946-9775-2c079cdfa69b.png	�����������ʻ�������	���ܲ���Э��	ʵս������	��ҵ�û�3	4	0	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
5	�ƶ�Ӧ�ò��Խ�����	2024-10-12 15:00:00	<h2>��������</h2><p>�����ƶ�Ӧ�ò��Ե����¼����;��顣</p><h2>���ⰲ��</h2><ul><li>iOS�Զ�������ʵ��</li><li>Android�����Բ���</li><li>�ƶ�Ӧ�������Ż�</li></ul>	/uploads/9caf57fe-182b-4141-abb4-d1d483179642.png	������ӻ�������	�ƶ���������	��������	��������Ա	1	1	\N	\N	2025-06-22 03:11:04	2025-06-22 03:11:04
7	������Լ�����չ�������ֻ�	2025-07-17 19:43:55	<h2>��������</h2><p>̽��������Լ��������·�չ���ƣ������Զ������ԡ�AI���ԡ��Ʋ��Ե�ǰ�ؼ�����</p><h2>��̰���</h2><ul><li>09:00-09:30 ��Ļʽ</li><li>09:30-10:30 �����ݽ���AI�ڲ����е�Ӧ��</li><li>10:45-11:45 ����������ԭ������ʵ��</li><li>14:00-15:00 Բ�����ۣ�������ҵδ��չ��</li></ul>	/uploads/73bc8ae9-478f-491b-b925-7bde348524d7.png	�������ʻ�������	�й��������Э��	����	��������Ա	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
8	�ƶ�Ӧ�ò��Լ���������	2025-07-04 03:59:51	<h2>��������</h2><p>�����ƶ�Ӧ�ò��Ե����¼�����ʵ�����飬����iOS��Androidƽ̨�Ĳ��Բ��ԡ�</p><h2>��������</h2><ul><li>�ƶ����Զ������Կ�ܶԱ�</li><li>���ܲ������ƶ�Ӧ���е�Ӧ��</li><li>�����Բ������ʵ��</li></ul>	/uploads/e3a2302c-c638-40f7-ba88-7b9831d03ac8.png	�Ϻ��Ƽ�����	�ƶ���������	����	��������Ա	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
9	������Ա�׼�ƶ���������	2024-12-26 02:00:00	<h2>����Ŀ��</h2><p>�ƶ���ҵ������Ա�׼���淶�������̺�����Ҫ��</p><h2>��������</h2><ul><li>�������̱�׼������</li><li>������׼�ƶ�</li><li>����ѡ�ͱ�׼</li><li>��Ա����Ҫ��</li></ul>	/uploads/05fd484a-e83e-4d75-9f31-67a78aed424c.png	�������԰	����������Ա�׼��ίԱ��	��׼����	��������Ա	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
10	��ҵ������ϵ������ѯ��	2025-07-11 01:30:00	<h2>��ѯ����</h2><p>Ϊ��ҵ�ṩ���ƻ��Ĳ�����ϵ���跽��������������ơ�����ѡ�͡��Ŷӽ���ȡ�</p><h2>��������</h2><ul><li>�����������</li><li>�������滮</li><li>�Ŷ���������</li><li>����������ϵ</li></ul>	/uploads/ba9daa9f-30d8-45cc-bae7-89fef860ad5d.png	����������԰	������ѯר����	��׼����	��������Ա	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
11	�Զ������Լ���������ѵ��	2024-12-30 09:00:00	<h2>��ѵĿ��</h2><p>����������Ա���Զ������Լ��ܣ����������Զ������Թ��ߺͿ�ܡ�</p><h2>��ѵ����</h2><ul><li>Selenium WebDriverʵս</li><li>Appium�ƶ����Զ���</li><li>�ӿ��Զ�������</li><li>�������������</li></ul>	/uploads/65c43dcd-d7be-4705-bbf3-87948e41c4cb.png	�����������԰	���Լ�����ѵ����	������ѵ	��������Ա	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
12	���ܲ��Թ���ʦ��֤��ѵ	2025-01-05 09:00:00	<h2>��֤Ŀ��</h2><p>����רҵ�����ܲ��Թ���ʦ���������ܲ��Ե��������̺ͼ�����</p><h2>��ѵ���</h2><ul><li>���ܲ��Ի�������</li><li>JMeter����ʹ��</li><li>���ܼ�������</li><li>�����Ż�����</li></ul>	/uploads/44dfff36-802b-4baa-9803-6d1f7a62e174.png	�ɶ�������	���ܲ�����֤����	������ѵ	��������Ա	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
13	���Թ��߿����������ֻ�	2025-01-10 14:00:00	<h2>��������</h2><p>̽�ֲ��Թ��߿����ļ������ƺ����ʵ��������Դ���Թ��ߵĿ�����ά�����顣</p><h2>��������</h2><ul><li>���Թ��߼ܹ����</li><li>��������Կ�ܿ���</li><li>AI�����Ĳ��Թ���</li><li>��Դ��Ŀά������</li></ul>	/uploads/21e8d110-ed7a-471a-8015-24f0d5a55630.png	�人������԰	���Թ��߿���������	�����з�	��������Ա	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
14	��Դ���Թ��߹����ߴ��	2025-01-15 09:00:00	<h2>���Ŀ��</h2><p>��ۿ�Դ���Թ��ߵĹ����ߣ���ͬ̽�ֿ�Դ��Ŀ�ķ�չ�����Э��ģʽ��</p><h2>�����</h2><ul><li>��Դ��Ŀչʾ</li><li>���������뽻��</li><li>Э��ģʽ����</li><li>δ����չ�滮</li></ul>	/uploads/d93f222d-8d8a-44e0-b838-6df79e908ca2.png	�������԰	��Դ���Թ�������	�����з�	��������Ա	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
15	������Թ�����ѵ�ƻ�������	2025-01-20 10:00:00	<h2>����Ŀ��</h2><p>ΪƫԶ������ѧ���ʹ�ҵ���ṩ��ѵ����������ѵ���ƶ����Լ������ռ���</p><h2>�ƻ�����</h2><ul><li>���߿γ̿���</li><li>������ѵ����</li><li>־Ը����ļ</li><li>�ʽ�ļ���ƻ�</li></ul>	/uploads/6c7121d6-7800-4d37-b1a7-3826af4978c4.png	�����йش�	���Լ�����������	�����ж�	��������Ա	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
16	������ҵ���������̳	2025-01-25 14:00:00	<h2>��̳����</h2><p>̽�ֲ�����ҵ���ƶ�������������������û�Ȩ�淽���������Ρ�</p><h2>��������</h2><ul><li>����������û���ȫ</li><li>������ҵ����������</li><li>��ҵ��׼��淶</li><li>���Ӱ��������</li></ul>	/uploads/c86d777a-75df-4e21-98df-9ca7449d8fd5.png	������ɽ	������������������	�����ж�	��������Ա	1	1	\N	\N	2025-07-04 11:03:22	2025-07-04 11:03:22
\.


--
-- TOC entry 9715 (class 0 OID 16805)
-- Dependencies: 614
-- Data for Name: meeting_feedback; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.meeting_feedback (id, meeting_id, user_id, user_name, company_name, gender, user_phone, user_email, arrival_method, arrival_info, arrival_time, rating, content, suggestions, organization_rating, content_rating, venue_rating, attachments, submit_time, create_time, update_time) FROM stdin;
1	1	9	user3	\N	\N	\N	\N	\N	\N	\N	3	����ͦ�õ�		0	0	0	\N	2025-06-24 15:17:18	2025-06-24 15:17:18	2025-06-24 15:17:17
2	7	9	user3	1	��	1	1	����	1	1	3	1	1	0	0	0	\N	2025-07-04 11:44:27	2025-07-04 11:44:27	2025-07-04 11:44:26
3	8	9	user3	1	��	1	1	��	1	1	3	11	1	2	2	2	\N	2025-07-04 12:00:23	2025-07-04 12:00:23	2025-07-04 12:00:22
\.


--
-- TOC entry 9695 (class 0 OID 16669)
-- Dependencies: 594
-- Data for Name: meeting_registration; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.meeting_registration (id, meeting_id, user_id, user_name, user_phone, user_email, company_name, status, registration_time, checkin_time, remarks, create_time, update_time) FROM stdin;
1	1	9	user3	\N	user3@qq.com	\N	0	2025-06-24 15:08:54	\N	\N	2025-06-24 15:08:54	2025-06-24 15:08:54
2	1	12	΢���û�	\N	\N	\N	0	2025-06-24 19:26:03	\N	\N	2025-06-24 19:26:03	2025-06-24 19:26:03
3	7	9	user3	\N	user3@qq.com	\N	0	2025-07-04 11:43:19	\N	\N	2025-07-04 11:43:19	2025-07-04 11:43:18
4	8	9	user3	\N	user3@qq.com	\N	0	2025-07-04 11:59:45	\N	\N	2025-07-04 11:59:45	2025-07-04 11:59:44
\.


--
-- TOC entry 9707 (class 0 OID 16747)
-- Dependencies: 606
-- Data for Name: news; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.news (id, title, summary, content, cover_image, author, author_id, category, content_images, videos, attachments, status, audit_time, audit_user_id, view_count, create_time, update_time) FROM stdin;
2	�Զ������Թ�����ȶԱȷ���	��ϸ�Ա��������������Զ������Թ��ߵ���ȱ������ó���	<h2>Selenium WebDriver</h2><p><strong>�ŵ㣺</strong></p><ul><li>��Դ���</li><li>֧�ֶ��ֱ������</li><li>������Ծ</li></ul><p><strong>ȱ�㣺</strong></p><ul><li>������Ը���</li><li>ִ���ٶȽ���</li></ul><h2>Cypress</h2><p><strong>�ŵ㣺</strong></p><ul><li>����ʹ�ú͵���</li><li>ִ���ٶȿ�</li><li>ʵʱ����</li></ul><p><strong>ȱ�㣺</strong></p><ul><li>��֧��JavaScript</li><li>�����֧������</li></ul>	/uploads/be4f21a2-80b4-4580-90b2-76d67a2b5da0.png	��ҵ�û�1	2	��ҵ��̬	\N	\N	\N	0	\N	\N	193	2025-06-22 03:11:04	2025-06-22 21:11:14
3	���ݿ����еĲ��Բ���	̽�������ݿ�������������ƶ���Ч�Ĳ��Բ���	<h2>���ݲ��Եĺ�������</h2><p>���ݲ���ǿ�����ڽ��롢�������ԡ����ٷ�����</p><h2>�������Ʋ���</h2><p>�����Իǰ�Ƶ��������ڽ׶Σ����������������ƽ׶Ρ�</p><h2>�Զ��������������е�����</h2><p>�Զ������������ݿ����ɹ��Ĺؼ�����֮һ��</p>	/uploads/66ed6f51-571d-4783-b213-9677634573a1.png	��ҵ�û�2	3	��ҵ��̬	\N	\N	\N	1	\N	\N	146	2025-06-22 03:11:04	2025-06-22 21:11:14
4	���ܲ������ʵ��ָ��	�������ϵͳ���ܲ��Եľ�������ʵ��	<h2>���ܲ��Թ滮</h2><p>�ƶ���ϸ�����ܲ��Լƻ�����ȷ����Ŀ��ͳ�����</p><h2>���Ի���׼��</h2><p>��������������ƵĲ��Ի�����</p><h2>��غͷ���</h2><p>ʵʱ���ϵͳ����ָ�꣬��ʱ��������ƿ����</p>	/uploads/5d6d114e-3fba-4f9e-bdf4-c87386d4c7c6.png	��������Ա	1	��ҵ��̬	\N	\N	\N	1	\N	\N	105	2025-06-22 03:11:04	2025-06-22 21:11:14
5	�ƶ�Ӧ�ò��Լ���Ҫ��	�ƶ�Ӧ�ò��Ե��ص�͹ؼ����������	<h2>�ƶ����Ե���ս</h2><p>�豸��Ƭ�������绷�����ӡ��û�����Ҫ��ߡ�</p><h2>�����Բ���</h2><p>ȷ��Ӧ���ڲ�ͬ�豸��ϵͳ�汾���������С�</p><h2>�����Ż�</h2><p>��עӦ������ʱ�䡢�ڴ�ʹ�á�������ĵ�ָ�ꡣ</p>	/uploads/d05899a8-d07f-4e33-800c-a79cec30e658.png	��ҵ�û�3	4	��ҵ��̬	\N	\N	\N	0	\N	\N	67	2025-06-22 03:11:04	2025-06-22 21:11:14
1	2025��������Լ�����չ����	����������������ҵ�����·�չ���ƺͼ������	<h2>����</h2><p>����������������Ŀ��ٷ�չ�����Լ���Ҳ�ڲ����ݽ��ʹ��¡����Ľ��������2024��������Լ����ķ�չ���ơ�</p><h2>AI�����Ĳ����Զ���</h2><p>�˹����ܼ����ڲ��������Ӧ��Խ��Խ�㷺���������ܲ����������ɡ��Զ���ȱ�ݼ��ȡ�</p><h2>��ԭ������</h2><p>�����Ƽ��㼼�����ռ�����ԭ�����Գ�Ϊ�µķ�չ����</p>	/uploads/2dfe70bd-c805-490e-aa3c-ad4b323ccb83.png	��������Ա	1	��ҵ��̬	\N	\N	\N	1	\N	\N	277	2025-06-22 03:11:04	2025-06-22 21:11:14
\.


--
-- TOC entry 9703 (class 0 OID 16726)
-- Dependencies: 602
-- Data for Name: tenant; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.tenant (id, tenant_code, tenant_name, contact_person, contact_phone, status, create_time, update_time) FROM stdin;
1	T001	���ԿƼ����޹�˾	�ž���	13800138001	1	2025-06-22 03:11:04	2025-06-22 03:11:04
2	T002	������Թ�˾	���	13800138002	1	2025-06-22 03:11:04	2025-06-22 03:11:04
3	T003	������������	������	13800138003	1	2025-06-22 03:11:04	2025-06-22 03:11:04
4	T004	�Զ�������ʵ����	�Ծ���	13800138004	1	2025-06-22 03:11:04	2025-06-22 03:11:04
5	T005	���ܲ�������	������	13800138005	1	2025-06-22 03:11:04	2025-06-22 03:11:04
\.


--
-- TOC entry 9701 (class 0 OID 16714)
-- Dependencies: 600
-- Data for Name: user; Type: TABLE DATA; Schema: cemenghui_now; Owner: system
--

COPY cemenghui_now.`user` (id, username, password, phone, email, nickname, gender, role, status, avatar, company_name, create_time, update_time) FROM stdin;
1	admin	$2a$10$Grdj6ESzHmPKE48jrrvGteliUNgkxYVeyh6YvYR3jzFLWRqLvcr.K	13800138000	admin@cemenghui.com	��������Ա	1	ADMIN	1	/uploads/fea83ca4-ee1e-439c-88ed-10ca3c95ac4f.jpeg	���˻��ܲ�	2025-06-22 03:11:04	2025-06-22 03:12:28
2	company1	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138001	company1@test.com	��ҵ�û�1	0	USER	1	/uploads/9480f065-7014-44ac-8301-7d86d6131f78.jpg	���ԿƼ����޹�˾	2025-06-22 03:11:04	2025-06-22 04:03:05
3	company2	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138002	company2@test.com	��ҵ�û�2	0	USER	1	\N	������Թ�˾	2025-06-22 03:11:04	2025-06-22 03:12:28
4	company3	$2a$10$Wb5z2x3VLqd9CmjGPwnIAuvF0nJqydzr5yGWBlYpSSEFBAkeJS5ou	13800138003	company3@test.com	��ҵ�û�3	0	USER	1	\N	������������	2025-06-22 03:11:04	2025-06-22 03:12:28
5	user1	$2a$10$yMRyuyW0FIqBnPIB2aj/DuudYqIF1erdwYu6W5dEUvybwYIltIp8C	1	1@qq.com	1	2	USER	1	/uploads/4d0bf446-01d6-47d0-bc8c-01bb16a88f3d.jpg	1	2025-06-22 03:12:13	2025-06-22 03:12:13
7	user2	$2a$10$IjyrV3VJzmGoWPg.Bk8Xv.J4WRIPLtoC8dXhDbU6ji4.v3uYhdD4G	\N	484855425@163.com	\N	0	USER	1	\N	\N	2025-06-22 06:08:06	2025-06-22 06:08:06
8	1111	$2a$10$sqwqQwaW016nKyHBE0.KHe1E3MnpZQyhQYHRCMECAGKqmt7GAOEAy	15115151515	15115151515@qq.com	\N	0	USER	1	\N	1	2025-06-22 23:19:30	2025-06-22 23:19:30
9	user3	$2a$10$rgekPmtXa.BS0vaoCG1mX.YiOXpKHPXSFTdRrO3u9wmFyTgNibSRu	\N	user3@qq.com	\N	0	USER	1	\N	\N	2025-06-24 14:24:50	2025-06-24 14:24:50
10	user4	$2a$10$xv1zEWjbqJ.CyVgvFoiPyeeu.n34M/BcqO./fXmozGy0wmbsA0cQ6	\N	user4@163.com	\N	0	USER	1	\N	\N	2025-06-24 14:47:41	2025-06-24 14:47:41
11	wx_1750763401213	wechat_user	\N	99@qq.com	΢���û�	0	USER	1	/uploads/3c80122c-6633-49b6-a8ef-aac4e07cc6e9.jpeg	\N	2025-06-24 19:10:01	2025-06-24 19:10:01
12	wx_1750764285398	wechat_user	\N	\N	΢���û�	0	USER	1	https://thirdwx.qlogo.cn/mmopen/vi_32/POgEwh4mIHO4nibH0KlMECNjjGxQUq24ZEaGT4poC6icRiccVGKSyXwibcPq4BWmiaIGuG1icwxaQX6grC9VemZoJ8rg/132	\N	2025-06-24 19:24:45	2025-06-24 19:24:45
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
5	12	course	10	��һ��	��һ��		��������Ա	2025-06-24 19:26:48	2025-06-24 19:26:47
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

