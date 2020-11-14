--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE catalog;




--
-- Drop roles
--

DROP ROLE catalog;


--
-- Roles
--

CREATE ROLE catalog;
ALTER ROLE catalog WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md56be3d84fa45e3612e5d22f1015b288af';






--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0 (Debian 13.0-1.pgdg100+1)
-- Dumped by pg_dump version 13.0 (Debian 13.0-1.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: catalog
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO catalog;



SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: catalog
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: catalog
--

ALTER DATABASE template1 IS_TEMPLATE = true;




SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: catalog
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "catalog" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0 (Debian 13.0-1.pgdg100+1)
-- Dumped by pg_dump version 13.0 (Debian 13.0-1.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: catalog; Type: DATABASE; Schema: -; Owner: catalog
--

CREATE DATABASE catalog WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE catalog OWNER TO catalog;

\connect catalog

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: core_store; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.core_store (
    id integer NOT NULL,
    key character varying(255),
    value text,
    type character varying(255),
    environment character varying(255),
    tag character varying(255)
);


ALTER TABLE public.core_store OWNER TO catalog;

--
-- Name: core_store_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.core_store_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_store_id_seq OWNER TO catalog;

--
-- Name: core_store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.core_store_id_seq OWNED BY public.core_store.id;


--
-- Name: edge_node; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.edge_node (
    id integer NOT NULL,
    published_at timestamp with time zone,
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    name character varying(255),
    description text,
    factory integer,
    rule integer
);


ALTER TABLE public.edge_node OWNER TO catalog;

--
-- Name: edge_node_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.edge_node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.edge_node_id_seq OWNER TO catalog;

--
-- Name: edge_node_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.edge_node_id_seq OWNED BY public.edge_node.id;


--
-- Name: factory; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.factory (
    id integer NOT NULL,
    name character varying(255),
    description text,
    published_at timestamp with time zone,
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.factory OWNER TO catalog;

--
-- Name: factory_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.factory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.factory_id_seq OWNER TO catalog;

--
-- Name: factory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.factory_id_seq OWNED BY public.factory.id;


--
-- Name: position; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public."position" (
    id integer NOT NULL,
    name character varying(255),
    description text,
    published_at timestamp with time zone,
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public."position" OWNER TO catalog;

--
-- Name: position_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.position_id_seq OWNER TO catalog;

--
-- Name: position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.position_id_seq OWNED BY public."position".id;


--
-- Name: rule; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.rule (
    id integer NOT NULL,
    name character varying(255),
    condition jsonb,
    edge_node integer,
    published_at timestamp with time zone,
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    sensor integer
);


ALTER TABLE public.rule OWNER TO catalog;

--
-- Name: rule_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.rule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rule_id_seq OWNER TO catalog;

--
-- Name: rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.rule_id_seq OWNED BY public.rule.id;


--
-- Name: sensor; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.sensor (
    id integer NOT NULL,
    name character varying(255),
    description text,
    edge_node integer,
    published_at timestamp with time zone,
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    sensor_type integer,
    rule integer
);


ALTER TABLE public.sensor OWNER TO catalog;

--
-- Name: sensor_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.sensor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sensor_id_seq OWNER TO catalog;

--
-- Name: sensor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.sensor_id_seq OWNED BY public.sensor.id;


--
-- Name: sensor_type; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.sensor_type (
    id integer NOT NULL,
    name character varying(255),
    description text,
    published_at timestamp with time zone,
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.sensor_type OWNER TO catalog;

--
-- Name: sensor_type_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.sensor_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sensor_type_id_seq OWNER TO catalog;

--
-- Name: sensor_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.sensor_type_id_seq OWNED BY public.sensor_type.id;


--
-- Name: shift_type; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.shift_type (
    id integer NOT NULL,
    name character varying(255),
    status boolean,
    time_in time without time zone,
    time_out time without time zone,
    published_at timestamp with time zone,
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.shift_type OWNER TO catalog;

--
-- Name: shift_type_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.shift_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shift_type_id_seq OWNER TO catalog;

--
-- Name: shift_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.shift_type_id_seq OWNED BY public.shift_type.id;


--
-- Name: strapi_administrator; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.strapi_administrator (
    id integer NOT NULL,
    firstname character varying(255),
    lastname character varying(255),
    username character varying(255),
    email character varying(255) NOT NULL,
    password character varying(255),
    "resetPasswordToken" character varying(255),
    "registrationToken" character varying(255),
    "isActive" boolean,
    blocked boolean
);


ALTER TABLE public.strapi_administrator OWNER TO catalog;

--
-- Name: strapi_administrator_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.strapi_administrator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.strapi_administrator_id_seq OWNER TO catalog;

--
-- Name: strapi_administrator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.strapi_administrator_id_seq OWNED BY public.strapi_administrator.id;


--
-- Name: strapi_permission; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.strapi_permission (
    id integer NOT NULL,
    action character varying(255) NOT NULL,
    subject character varying(255),
    fields jsonb,
    conditions jsonb,
    role integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.strapi_permission OWNER TO catalog;

--
-- Name: strapi_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.strapi_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.strapi_permission_id_seq OWNER TO catalog;

--
-- Name: strapi_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.strapi_permission_id_seq OWNED BY public.strapi_permission.id;


--
-- Name: strapi_role; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.strapi_role (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(255) NOT NULL,
    description character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.strapi_role OWNER TO catalog;

--
-- Name: strapi_role_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.strapi_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.strapi_role_id_seq OWNER TO catalog;

--
-- Name: strapi_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.strapi_role_id_seq OWNED BY public.strapi_role.id;


--
-- Name: strapi_users_roles; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.strapi_users_roles (
    id integer NOT NULL,
    user_id integer,
    role_id integer
);


ALTER TABLE public.strapi_users_roles OWNER TO catalog;

--
-- Name: strapi_users_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.strapi_users_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.strapi_users_roles_id_seq OWNER TO catalog;

--
-- Name: strapi_users_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.strapi_users_roles_id_seq OWNED BY public.strapi_users_roles.id;


--
-- Name: strapi_webhooks; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.strapi_webhooks (
    id integer NOT NULL,
    name character varying(255),
    url text,
    headers jsonb,
    events jsonb,
    enabled boolean
);


ALTER TABLE public.strapi_webhooks OWNER TO catalog;

--
-- Name: strapi_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.strapi_webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.strapi_webhooks_id_seq OWNER TO catalog;

--
-- Name: strapi_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.strapi_webhooks_id_seq OWNED BY public.strapi_webhooks.id;


--
-- Name: transaction; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.transaction (
    id integer NOT NULL,
    users_permissions_user integer,
    published_at timestamp with time zone,
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    rule integer,
    shift_type integer,
    historys jsonb
);


ALTER TABLE public.transaction OWNER TO catalog;

--
-- Name: transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_id_seq OWNER TO catalog;

--
-- Name: transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.transaction_id_seq OWNED BY public.transaction.id;


--
-- Name: upload_file; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.upload_file (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "alternativeText" character varying(255),
    caption character varying(255),
    width integer,
    height integer,
    formats jsonb,
    hash character varying(255) NOT NULL,
    ext character varying(255),
    mime character varying(255) NOT NULL,
    size numeric(10,2) NOT NULL,
    url character varying(255) NOT NULL,
    "previewUrl" character varying(255),
    provider character varying(255) NOT NULL,
    provider_metadata jsonb,
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.upload_file OWNER TO catalog;

--
-- Name: upload_file_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.upload_file_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.upload_file_id_seq OWNER TO catalog;

--
-- Name: upload_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.upload_file_id_seq OWNED BY public.upload_file.id;


--
-- Name: upload_file_morph; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.upload_file_morph (
    id integer NOT NULL,
    upload_file_id integer,
    related_id integer,
    related_type text,
    field text,
    "order" integer
);


ALTER TABLE public.upload_file_morph OWNER TO catalog;

--
-- Name: upload_file_morph_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public.upload_file_morph_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.upload_file_morph_id_seq OWNER TO catalog;

--
-- Name: upload_file_morph_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public.upload_file_morph_id_seq OWNED BY public.upload_file_morph.id;


--
-- Name: users-permissions_permission; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public."users-permissions_permission" (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    controller character varying(255) NOT NULL,
    action character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    policy character varying(255),
    role integer,
    created_by integer,
    updated_by integer
);


ALTER TABLE public."users-permissions_permission" OWNER TO catalog;

--
-- Name: users-permissions_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public."users-permissions_permission_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."users-permissions_permission_id_seq" OWNER TO catalog;

--
-- Name: users-permissions_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public."users-permissions_permission_id_seq" OWNED BY public."users-permissions_permission".id;


--
-- Name: users-permissions_role; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public."users-permissions_role" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255),
    created_by integer,
    updated_by integer
);


ALTER TABLE public."users-permissions_role" OWNER TO catalog;

--
-- Name: users-permissions_role_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public."users-permissions_role_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."users-permissions_role_id_seq" OWNER TO catalog;

--
-- Name: users-permissions_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public."users-permissions_role_id_seq" OWNED BY public."users-permissions_role".id;


--
-- Name: users-permissions_user; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public."users-permissions_user" (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    provider character varying(255),
    password character varying(255),
    "resetPasswordToken" character varying(255),
    "confirmationToken" character varying(255),
    confirmed boolean,
    blocked boolean,
    role integer,
    created_by integer,
    updated_by integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "phoneNumber" character varying(255),
    factory integer,
    "position" integer
);


ALTER TABLE public."users-permissions_user" OWNER TO catalog;

--
-- Name: users-permissions_user_id_seq; Type: SEQUENCE; Schema: public; Owner: catalog
--

CREATE SEQUENCE public."users-permissions_user_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."users-permissions_user_id_seq" OWNER TO catalog;

--
-- Name: users-permissions_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: catalog
--

ALTER SEQUENCE public."users-permissions_user_id_seq" OWNED BY public."users-permissions_user".id;


--
-- Name: core_store id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.core_store ALTER COLUMN id SET DEFAULT nextval('public.core_store_id_seq'::regclass);


--
-- Name: edge_node id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.edge_node ALTER COLUMN id SET DEFAULT nextval('public.edge_node_id_seq'::regclass);


--
-- Name: factory id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.factory ALTER COLUMN id SET DEFAULT nextval('public.factory_id_seq'::regclass);


--
-- Name: position id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public."position" ALTER COLUMN id SET DEFAULT nextval('public.position_id_seq'::regclass);


--
-- Name: rule id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.rule ALTER COLUMN id SET DEFAULT nextval('public.rule_id_seq'::regclass);


--
-- Name: sensor id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.sensor ALTER COLUMN id SET DEFAULT nextval('public.sensor_id_seq'::regclass);


--
-- Name: sensor_type id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.sensor_type ALTER COLUMN id SET DEFAULT nextval('public.sensor_type_id_seq'::regclass);


--
-- Name: shift_type id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.shift_type ALTER COLUMN id SET DEFAULT nextval('public.shift_type_id_seq'::regclass);


--
-- Name: strapi_administrator id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_administrator ALTER COLUMN id SET DEFAULT nextval('public.strapi_administrator_id_seq'::regclass);


--
-- Name: strapi_permission id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_permission ALTER COLUMN id SET DEFAULT nextval('public.strapi_permission_id_seq'::regclass);


--
-- Name: strapi_role id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_role ALTER COLUMN id SET DEFAULT nextval('public.strapi_role_id_seq'::regclass);


--
-- Name: strapi_users_roles id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_users_roles ALTER COLUMN id SET DEFAULT nextval('public.strapi_users_roles_id_seq'::regclass);


--
-- Name: strapi_webhooks id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_webhooks ALTER COLUMN id SET DEFAULT nextval('public.strapi_webhooks_id_seq'::regclass);


--
-- Name: transaction id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.transaction ALTER COLUMN id SET DEFAULT nextval('public.transaction_id_seq'::regclass);


--
-- Name: upload_file id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.upload_file ALTER COLUMN id SET DEFAULT nextval('public.upload_file_id_seq'::regclass);


--
-- Name: upload_file_morph id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.upload_file_morph ALTER COLUMN id SET DEFAULT nextval('public.upload_file_morph_id_seq'::regclass);


--
-- Name: users-permissions_permission id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public."users-permissions_permission" ALTER COLUMN id SET DEFAULT nextval('public."users-permissions_permission_id_seq"'::regclass);


--
-- Name: users-permissions_role id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public."users-permissions_role" ALTER COLUMN id SET DEFAULT nextval('public."users-permissions_role_id_seq"'::regclass);


--
-- Name: users-permissions_user id; Type: DEFAULT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public."users-permissions_user" ALTER COLUMN id SET DEFAULT nextval('public."users-permissions_user_id_seq"'::regclass);


--
-- Data for Name: core_store; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.core_store (id, key, value, type, environment, tag) FROM stdin;
34	model_def_application::rule.rule	{"uid":"application::rule.rule","collectionName":"rule","kind":"collectionType","info":{"name":"rule","description":""},"options":{"increments":true,"timestamps":["created_at","updated_at"],"draftAndPublish":true},"attributes":{"name":{"type":"string"},"condition":{"type":"json"},"sensor":{"model":"sensor","via":"rule"},"transactions":{"collection":"transaction","via":"rule","isVirtual":true},"published_at":{"type":"datetime","configurable":false},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
2	model_def_strapi::webhooks	{"uid":"strapi::webhooks","collectionName":"strapi_webhooks","info":{"name":"Strapi webhooks","description":""},"options":{"timestamps":false},"attributes":{"name":{"type":"string"},"url":{"type":"text"},"headers":{"type":"json"},"events":{"type":"json"},"enabled":{"type":"boolean"}}}	object	\N	\N
10	plugin_documentation_config	{"restrictedAccess":false}	object		
12	plugin_upload_settings	{"sizeOptimization":true,"responsiveDimensions":true}	object	development	
4	model_def_strapi::role	{"uid":"strapi::role","collectionName":"strapi_role","kind":"collectionType","info":{"name":"Role","description":""},"options":{"timestamps":["created_at","updated_at"]},"attributes":{"name":{"type":"string","minLength":1,"unique":true,"configurable":false,"required":true},"code":{"type":"string","minLength":1,"unique":true,"configurable":false,"required":true},"description":{"type":"string","configurable":false},"users":{"configurable":false,"collection":"user","via":"roles","plugin":"admin","attribute":"user","column":"id","isVirtual":true},"permissions":{"configurable":false,"plugin":"admin","collection":"permission","via":"role","isVirtual":true}}}	object	\N	\N
7	model_def_plugins::users-permissions.permission	{"uid":"plugins::users-permissions.permission","collectionName":"users-permissions_permission","kind":"collectionType","info":{"name":"permission","description":""},"options":{"timestamps":false},"attributes":{"type":{"type":"string","required":true,"configurable":false},"controller":{"type":"string","required":true,"configurable":false},"action":{"type":"string","required":true,"configurable":false},"enabled":{"type":"boolean","required":true,"configurable":false},"policy":{"type":"string","configurable":false},"role":{"model":"role","via":"permissions","plugin":"users-permissions","configurable":false},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
13	plugin_content_manager_configuration_content_types::plugins::upload.file	{"uid":"plugins::upload.file","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"name","defaultSortBy":"name","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"name":{"edit":{"label":"Name","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Name","searchable":true,"sortable":true}},"alternativeText":{"edit":{"label":"AlternativeText","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"AlternativeText","searchable":true,"sortable":true}},"caption":{"edit":{"label":"Caption","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Caption","searchable":true,"sortable":true}},"width":{"edit":{"label":"Width","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Width","searchable":true,"sortable":true}},"height":{"edit":{"label":"Height","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Height","searchable":true,"sortable":true}},"formats":{"edit":{"label":"Formats","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Formats","searchable":false,"sortable":false}},"hash":{"edit":{"label":"Hash","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Hash","searchable":true,"sortable":true}},"ext":{"edit":{"label":"Ext","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Ext","searchable":true,"sortable":true}},"mime":{"edit":{"label":"Mime","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Mime","searchable":true,"sortable":true}},"size":{"edit":{"label":"Size","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Size","searchable":true,"sortable":true}},"url":{"edit":{"label":"Url","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Url","searchable":true,"sortable":true}},"previewUrl":{"edit":{"label":"PreviewUrl","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"PreviewUrl","searchable":true,"sortable":true}},"provider":{"edit":{"label":"Provider","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Provider","searchable":true,"sortable":true}},"provider_metadata":{"edit":{"label":"Provider_metadata","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Provider_metadata","searchable":false,"sortable":false}},"related":{"edit":{"label":"Related","description":"","placeholder":"","visible":true,"editable":true,"mainField":"id"},"list":{"label":"Related","searchable":false,"sortable":false}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","name","alternativeText","caption"],"editRelations":["related"],"edit":[[{"name":"name","size":6},{"name":"alternativeText","size":6}],[{"name":"caption","size":6},{"name":"width","size":4}],[{"name":"height","size":4}],[{"name":"formats","size":12}],[{"name":"hash","size":6},{"name":"ext","size":6}],[{"name":"mime","size":6},{"name":"size","size":4}],[{"name":"url","size":6},{"name":"previewUrl","size":6}],[{"name":"provider","size":6}],[{"name":"provider_metadata","size":12}]]}}	object		
8	model_def_plugins::users-permissions.role	{"uid":"plugins::users-permissions.role","collectionName":"users-permissions_role","kind":"collectionType","info":{"name":"role","description":""},"options":{"timestamps":false},"attributes":{"name":{"type":"string","minLength":3,"required":true,"configurable":false},"description":{"type":"string","configurable":false},"type":{"type":"string","unique":true,"configurable":false},"permissions":{"collection":"permission","via":"role","plugin":"users-permissions","configurable":false,"isVirtual":true},"users":{"collection":"user","via":"role","configurable":false,"plugin":"users-permissions","isVirtual":true},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
1	model_def_strapi::core-store	{"uid":"strapi::core-store","collectionName":"core_store","info":{"name":"core_store","description":""},"options":{"timestamps":false},"attributes":{"key":{"type":"string"},"value":{"type":"text"},"type":{"type":"string"},"environment":{"type":"string"},"tag":{"type":"string"}}}	object	\N	\N
35	plugin_content_manager_configuration_content_types::application::rule.rule	{"uid":"application::rule.rule","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"name","defaultSortBy":"name","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"name":{"edit":{"label":"Name","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Name","searchable":true,"sortable":true}},"condition":{"edit":{"label":"Condition","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Condition","searchable":false,"sortable":false}},"sensor":{"edit":{"label":"Sensor","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Sensor","searchable":false,"sortable":false}},"transactions":{"edit":{"label":"Transactions","description":"","placeholder":"","visible":true,"editable":true,"mainField":"id"},"list":{"label":"Transactions","searchable":false,"sortable":false}},"published_at":{"edit":{"label":"Published_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Published_at","searchable":true,"sortable":true}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","name","published_at","created_at"],"edit":[[{"name":"name","size":6}],[{"name":"condition","size":12}]],"editRelations":["transactions","sensor"]}}	object		
3	model_def_strapi::permission	{"uid":"strapi::permission","collectionName":"strapi_permission","kind":"collectionType","info":{"name":"Permission","description":""},"options":{"timestamps":["created_at","updated_at"]},"attributes":{"action":{"type":"string","minLength":1,"configurable":false,"required":true},"subject":{"type":"string","minLength":1,"configurable":false,"required":false},"fields":{"type":"json","configurable":false,"required":false,"default":[]},"conditions":{"type":"json","configurable":false,"required":false,"default":[]},"role":{"configurable":false,"model":"role","plugin":"admin"}}}	object	\N	\N
5	model_def_strapi::user	{"uid":"strapi::user","collectionName":"strapi_administrator","kind":"collectionType","info":{"name":"User","description":""},"options":{"timestamps":false},"attributes":{"firstname":{"type":"string","unique":false,"minLength":1,"configurable":false,"required":false},"lastname":{"type":"string","unique":false,"minLength":1,"configurable":false,"required":false},"username":{"type":"string","unique":false,"configurable":false,"required":false},"email":{"type":"email","minLength":6,"configurable":false,"required":true,"unique":true,"private":true},"password":{"type":"password","minLength":6,"configurable":false,"required":false,"private":true},"resetPasswordToken":{"type":"string","configurable":false,"private":true},"registrationToken":{"type":"string","configurable":false,"private":true},"isActive":{"type":"boolean","default":false,"configurable":false,"private":true},"roles":{"collection":"role","collectionName":"strapi_users_roles","via":"users","dominant":true,"plugin":"admin","configurable":false,"private":true,"attribute":"role","column":"id","isVirtual":true},"blocked":{"type":"boolean","default":false,"configurable":false,"private":true}}}	object	\N	\N
36	model_def_application::shift-type.shift-type	{"uid":"application::shift-type.shift-type","collectionName":"shift_type","kind":"collectionType","info":{"name":"shift_type"},"options":{"increments":true,"timestamps":["created_at","updated_at"],"draftAndPublish":true},"attributes":{"name":{"type":"string"},"status":{"type":"boolean","default":false},"time_in":{"type":"time"},"time_out":{"type":"time"},"transactions":{"via":"shift_type","collection":"transaction","isVirtual":true},"published_at":{"type":"datetime","configurable":false},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
6	model_def_plugins::upload.file	{"uid":"plugins::upload.file","collectionName":"upload_file","kind":"collectionType","info":{"name":"file","description":""},"options":{"timestamps":["created_at","updated_at"]},"attributes":{"name":{"type":"string","configurable":false,"required":true},"alternativeText":{"type":"string","configurable":false},"caption":{"type":"string","configurable":false},"width":{"type":"integer","configurable":false},"height":{"type":"integer","configurable":false},"formats":{"type":"json","configurable":false},"hash":{"type":"string","configurable":false,"required":true},"ext":{"type":"string","configurable":false},"mime":{"type":"string","configurable":false,"required":true},"size":{"type":"decimal","configurable":false,"required":true},"url":{"type":"string","configurable":false,"required":true},"previewUrl":{"type":"string","configurable":false},"provider":{"type":"string","configurable":false,"required":true},"provider_metadata":{"type":"json","configurable":false},"related":{"collection":"*","filter":"field","configurable":false},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
22	model_def_application::factory.factory	{"uid":"application::factory.factory","collectionName":"factory","kind":"collectionType","info":{"name":"factory","description":""},"options":{"increments":true,"timestamps":["created_at","updated_at"],"draftAndPublish":true},"attributes":{"name":{"type":"string"},"description":{"type":"text"},"edge_nodes":{"via":"factory","collection":"edge-node","isVirtual":true},"users_permissions_users":{"plugin":"users-permissions","collection":"user","via":"factory","isVirtual":true},"published_at":{"type":"datetime","configurable":false},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
23	plugin_content_manager_configuration_content_types::application::factory.factory	{"uid":"application::factory.factory","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"name","defaultSortBy":"name","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"name":{"edit":{"label":"Name","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Name","searchable":true,"sortable":true}},"description":{"edit":{"label":"Description","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Description","searchable":true,"sortable":true}},"edge_nodes":{"edit":{"label":"Edge_nodes","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Edge_nodes","searchable":false,"sortable":false}},"users_permissions_users":{"edit":{"label":"Users_permissions_users","description":"","placeholder":"","visible":true,"editable":true,"mainField":"username"},"list":{"label":"Users_permissions_users","searchable":false,"sortable":false}},"published_at":{"edit":{"label":"Published_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Published_at","searchable":true,"sortable":true}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","name","description","published_at"],"edit":[[{"name":"name","size":6},{"name":"description","size":6}]],"editRelations":["edge_nodes","users_permissions_users"]}}	object		
37	plugin_content_manager_configuration_content_types::application::shift-type.shift-type	{"uid":"application::shift-type.shift-type","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"name","defaultSortBy":"name","defaultSortOrder":"ASC"},"metadatas":{"published_at":{"edit":{"label":"Published_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Published_at","searchable":true,"sortable":true}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"name":{"edit":{"label":"Name","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Name","searchable":true,"sortable":true}},"status":{"edit":{"label":"Status","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Status","searchable":true,"sortable":true}},"transactions":{"edit":{"label":"Transactions","description":"","placeholder":"","visible":true,"editable":true,"mainField":"id"},"list":{"label":"Transactions","searchable":false,"sortable":false}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}},"time_in":{"edit":{"label":"Time_in","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Time_in","searchable":true,"sortable":true}},"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"time_out":{"edit":{"label":"Time_out","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Time_out","searchable":true,"sortable":true}}},"layouts":{"list":["id","name","time_in","time_out"],"edit":[[{"name":"name","size":6},{"name":"status","size":4}],[{"name":"time_in","size":4},{"name":"time_out","size":4}]],"editRelations":["transactions"]}}	object		
24	model_def_application::edge-node.edge-node	{"uid":"application::edge-node.edge-node","collectionName":"edge_node","kind":"collectionType","info":{"name":"edge_node","description":""},"options":{"increments":true,"timestamps":["created_at","updated_at"],"draftAndPublish":true},"attributes":{"name":{"type":"string"},"description":{"type":"text"},"factory":{"model":"factory","via":"edge_nodes"},"sensors":{"collection":"sensor","via":"edge_node","isVirtual":true},"published_at":{"type":"datetime","configurable":false},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
9	model_def_plugins::users-permissions.user	{"uid":"plugins::users-permissions.user","collectionName":"users-permissions_user","kind":"collectionType","info":{"name":"user","description":""},"options":{"draftAndPublish":false,"timestamps":["created_at","updated_at"]},"attributes":{"username":{"type":"string","minLength":3,"unique":true,"configurable":false,"required":true},"email":{"type":"email","minLength":6,"configurable":false,"required":true},"provider":{"type":"string","configurable":false},"password":{"type":"password","minLength":6,"configurable":false,"private":true},"resetPasswordToken":{"type":"string","configurable":false,"private":true},"confirmationToken":{"type":"string","configurable":false,"private":true},"confirmed":{"type":"boolean","default":false,"configurable":false},"blocked":{"type":"boolean","default":false,"configurable":false},"role":{"model":"role","via":"users","plugin":"users-permissions","configurable":false},"phoneNumber":{"type":"string"},"factory":{"via":"users_permissions_users","model":"factory"},"position":{"via":"users_permissions_users","model":"position"},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
16	plugin_content_manager_configuration_content_types::strapi::role	{"uid":"strapi::role","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"name","defaultSortBy":"name","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"name":{"edit":{"label":"Name","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Name","searchable":true,"sortable":true}},"code":{"edit":{"label":"Code","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Code","searchable":true,"sortable":true}},"description":{"edit":{"label":"Description","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Description","searchable":true,"sortable":true}},"users":{"edit":{"label":"Users","description":"","placeholder":"","visible":true,"editable":true,"mainField":"firstname"},"list":{"label":"Users","searchable":false,"sortable":false}},"permissions":{"edit":{"label":"Permissions","description":"","placeholder":"","visible":true,"editable":true,"mainField":"action"},"list":{"label":"Permissions","searchable":false,"sortable":false}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","name","code","description"],"editRelations":["users","permissions"],"edit":[[{"name":"name","size":6},{"name":"code","size":6}],[{"name":"description","size":6}]]}}	object		
15	plugin_content_manager_configuration_content_types::strapi::permission	{"uid":"strapi::permission","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"action","defaultSortBy":"action","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"action":{"edit":{"label":"Action","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Action","searchable":true,"sortable":true}},"subject":{"edit":{"label":"Subject","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Subject","searchable":true,"sortable":true}},"fields":{"edit":{"label":"Fields","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Fields","searchable":false,"sortable":false}},"conditions":{"edit":{"label":"Conditions","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Conditions","searchable":false,"sortable":false}},"role":{"edit":{"label":"Role","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Role","searchable":false,"sortable":false}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","action","subject","created_at"],"editRelations":["role"],"edit":[[{"name":"action","size":6},{"name":"subject","size":6}],[{"name":"fields","size":12}],[{"name":"conditions","size":12}]]}}	object		
25	plugin_content_manager_configuration_content_types::application::edge-node.edge-node	{"uid":"application::edge-node.edge-node","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"id","defaultSortBy":"id","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"name":{"edit":{"label":"Name","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Name","searchable":true,"sortable":true}},"description":{"edit":{"label":"Description","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Description","searchable":true,"sortable":true}},"factory":{"edit":{"label":"Factory","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Factory","searchable":false,"sortable":false}},"sensors":{"edit":{"label":"Sensors","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Sensors","searchable":false,"sortable":false}},"published_at":{"edit":{"label":"Published_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Published_at","searchable":true,"sortable":true}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","name","description","created_at"],"edit":[[{"name":"name","size":6},{"name":"description","size":6}]],"editRelations":["factory","sensors"]}}	object		
26	model_def_application::sensor.sensor	{"uid":"application::sensor.sensor","collectionName":"sensor","kind":"collectionType","info":{"name":"sensor","description":""},"options":{"increments":true,"timestamps":["created_at","updated_at"],"draftAndPublish":true},"attributes":{"name":{"type":"string"},"description":{"type":"text"},"edge_node":{"via":"sensors","model":"edge-node"},"sensor_type":{"model":"sensor-type","via":"sensors"},"rule":{"via":"sensor","model":"rule"},"published_at":{"type":"datetime","configurable":false},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
27	plugin_content_manager_configuration_content_types::application::sensor.sensor	{"uid":"application::sensor.sensor","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"name","defaultSortBy":"name","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"name":{"edit":{"label":"Name","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Name","searchable":true,"sortable":true}},"description":{"edit":{"label":"Description","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Description","searchable":true,"sortable":true}},"edge_node":{"edit":{"label":"Edge_node","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Edge_node","searchable":false,"sortable":false}},"sensor_type":{"edit":{"label":"Sensor_type","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Sensor_type","searchable":false,"sortable":false}},"rule":{"edit":{"label":"Rule","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Rule","searchable":false,"sortable":false}},"published_at":{"edit":{"label":"Published_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Published_at","searchable":true,"sortable":true}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","name","description","published_at"],"edit":[[{"name":"name","size":6},{"name":"description","size":6}]],"editRelations":["edge_node","sensor_type","rule"]}}	object		
28	model_def_application::sensor-type.sensor-type	{"uid":"application::sensor-type.sensor-type","collectionName":"sensor_type","kind":"collectionType","info":{"name":"sensor_type"},"options":{"increments":true,"timestamps":["created_at","updated_at"],"draftAndPublish":true},"attributes":{"name":{"type":"string"},"description":{"type":"text"},"sensors":{"via":"sensor_type","collection":"sensor","isVirtual":true},"published_at":{"type":"datetime","configurable":false},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
29	plugin_content_manager_configuration_content_types::application::sensor-type.sensor-type	{"uid":"application::sensor-type.sensor-type","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"name","defaultSortBy":"name","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"name":{"edit":{"label":"Name","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Name","searchable":true,"sortable":true}},"description":{"edit":{"label":"Description","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Description","searchable":true,"sortable":true}},"sensors":{"edit":{"label":"Sensors","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Sensors","searchable":false,"sortable":false}},"published_at":{"edit":{"label":"Published_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Published_at","searchable":true,"sortable":true}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","name","description","published_at"],"edit":[[{"name":"name","size":6},{"name":"description","size":6}]],"editRelations":["sensors"]}}	object		
30	model_def_application::transaction.transaction	{"uid":"application::transaction.transaction","collectionName":"transaction","kind":"collectionType","info":{"name":"transaction","description":""},"options":{"increments":true,"timestamps":["created_at","updated_at"],"draftAndPublish":true},"attributes":{"users_permissions_user":{"plugin":"users-permissions","model":"user"},"rule":{"via":"transactions","model":"rule"},"shift_type":{"model":"shift-type","via":"transactions"},"historys":{"type":"json"},"published_at":{"type":"datetime","configurable":false},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
31	plugin_content_manager_configuration_content_types::application::transaction.transaction	{"uid":"application::transaction.transaction","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"id","defaultSortBy":"id","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"users_permissions_user":{"edit":{"label":"Users_permissions_user","description":"","placeholder":"","visible":true,"editable":true,"mainField":"username"},"list":{"label":"Users_permissions_user","searchable":false,"sortable":false}},"rule":{"edit":{"label":"Rule","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Rule","searchable":false,"sortable":false}},"shift_type":{"edit":{"label":"Shift_type","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Shift_type","searchable":false,"sortable":false}},"historys":{"edit":{"label":"Historys","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Historys","searchable":false,"sortable":false}},"published_at":{"edit":{"label":"Published_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Published_at","searchable":true,"sortable":true}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","published_at","created_at","updated_at"],"edit":[[{"name":"historys","size":12}]],"editRelations":["users_permissions_user","rule","shift_type"]}}	object		
32	model_def_application::position.position	{"uid":"application::position.position","collectionName":"position","kind":"collectionType","info":{"name":"position"},"options":{"increments":true,"timestamps":["created_at","updated_at"],"draftAndPublish":true},"attributes":{"name":{"type":"string"},"description":{"type":"text"},"users_permissions_users":{"plugin":"users-permissions","collection":"user","via":"position","isVirtual":true},"published_at":{"type":"datetime","configurable":false},"created_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true},"updated_by":{"model":"user","plugin":"admin","configurable":false,"writable":false,"private":true}}}	object	\N	\N
33	plugin_content_manager_configuration_content_types::application::position.position	{"uid":"application::position.position","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"name","defaultSortBy":"name","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"name":{"edit":{"label":"Name","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Name","searchable":true,"sortable":true}},"description":{"edit":{"label":"Description","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Description","searchable":true,"sortable":true}},"users_permissions_users":{"edit":{"label":"Users_permissions_users","description":"","placeholder":"","visible":true,"editable":true,"mainField":"username"},"list":{"label":"Users_permissions_users","searchable":false,"sortable":false}},"published_at":{"edit":{"label":"Published_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Published_at","searchable":true,"sortable":true}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","name","description","published_at"],"editRelations":["users_permissions_users"],"edit":[[{"name":"name","size":6},{"name":"description","size":6}]]}}	object		
14	plugin_content_manager_configuration_content_types::plugins::users-permissions.permission	{"uid":"plugins::users-permissions.permission","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"type","defaultSortBy":"type","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"type":{"edit":{"label":"Type","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Type","searchable":true,"sortable":true}},"controller":{"edit":{"label":"Controller","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Controller","searchable":true,"sortable":true}},"action":{"edit":{"label":"Action","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Action","searchable":true,"sortable":true}},"enabled":{"edit":{"label":"Enabled","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Enabled","searchable":true,"sortable":true}},"policy":{"edit":{"label":"Policy","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Policy","searchable":true,"sortable":true}},"role":{"edit":{"label":"Role","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Role","searchable":false,"sortable":false}}},"layouts":{"list":["id","type","controller","action"],"editRelations":["role"],"edit":[[{"name":"type","size":6},{"name":"controller","size":6}],[{"name":"action","size":6},{"name":"enabled","size":4}],[{"name":"policy","size":6}]]}}	object		
18	plugin_content_manager_configuration_content_types::plugins::users-permissions.role	{"uid":"plugins::users-permissions.role","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"name","defaultSortBy":"name","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"name":{"edit":{"label":"Name","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Name","searchable":true,"sortable":true}},"description":{"edit":{"label":"Description","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Description","searchable":true,"sortable":true}},"type":{"edit":{"label":"Type","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Type","searchable":true,"sortable":true}},"permissions":{"edit":{"label":"Permissions","description":"","placeholder":"","visible":true,"editable":true,"mainField":"type"},"list":{"label":"Permissions","searchable":false,"sortable":false}},"users":{"edit":{"label":"Users","description":"","placeholder":"","visible":true,"editable":true,"mainField":"username"},"list":{"label":"Users","searchable":false,"sortable":false}}},"layouts":{"list":["id","name","description","type"],"editRelations":["permissions","users"],"edit":[[{"name":"name","size":6},{"name":"description","size":6}],[{"name":"type","size":6}]]}}	object		
17	plugin_content_manager_configuration_content_types::strapi::user	{"uid":"strapi::user","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"firstname","defaultSortBy":"firstname","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"firstname":{"edit":{"label":"Firstname","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Firstname","searchable":true,"sortable":true}},"lastname":{"edit":{"label":"Lastname","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Lastname","searchable":true,"sortable":true}},"username":{"edit":{"label":"Username","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Username","searchable":true,"sortable":true}},"email":{"edit":{"label":"Email","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Email","searchable":true,"sortable":true}},"password":{"edit":{"label":"Password","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Password","searchable":true,"sortable":true}},"resetPasswordToken":{"edit":{"label":"ResetPasswordToken","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"ResetPasswordToken","searchable":true,"sortable":true}},"registrationToken":{"edit":{"label":"RegistrationToken","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"RegistrationToken","searchable":true,"sortable":true}},"isActive":{"edit":{"label":"IsActive","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"IsActive","searchable":true,"sortable":true}},"roles":{"edit":{"label":"Roles","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Roles","searchable":false,"sortable":false}},"blocked":{"edit":{"label":"Blocked","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Blocked","searchable":true,"sortable":true}}},"layouts":{"list":["id","firstname","lastname","username"],"editRelations":["roles"],"edit":[[{"name":"firstname","size":6},{"name":"lastname","size":6}],[{"name":"username","size":6},{"name":"email","size":6}],[{"name":"password","size":6},{"name":"resetPasswordToken","size":6}],[{"name":"registrationToken","size":6},{"name":"isActive","size":4}],[{"name":"blocked","size":4}]]}}	object		
19	plugin_content_manager_configuration_content_types::plugins::users-permissions.user	{"uid":"plugins::users-permissions.user","settings":{"bulkable":true,"filterable":true,"searchable":true,"pageSize":10,"mainField":"username","defaultSortBy":"username","defaultSortOrder":"ASC"},"metadatas":{"id":{"edit":{},"list":{"label":"Id","searchable":true,"sortable":true}},"username":{"edit":{"label":"Username","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Username","searchable":true,"sortable":true}},"email":{"edit":{"label":"Email","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Email","searchable":true,"sortable":true}},"provider":{"edit":{"label":"Provider","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Provider","searchable":true,"sortable":true}},"password":{"edit":{"label":"Password","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Password","searchable":true,"sortable":true}},"resetPasswordToken":{"edit":{"label":"ResetPasswordToken","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"ResetPasswordToken","searchable":true,"sortable":true}},"confirmationToken":{"edit":{"label":"ConfirmationToken","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"ConfirmationToken","searchable":true,"sortable":true}},"confirmed":{"edit":{"label":"Confirmed","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Confirmed","searchable":true,"sortable":true}},"blocked":{"edit":{"label":"Blocked","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"Blocked","searchable":true,"sortable":true}},"role":{"edit":{"label":"Role","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Role","searchable":false,"sortable":false}},"phoneNumber":{"edit":{"label":"PhoneNumber","description":"","placeholder":"","visible":true,"editable":true},"list":{"label":"PhoneNumber","searchable":true,"sortable":true}},"factory":{"edit":{"label":"Factory","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Factory","searchable":false,"sortable":false}},"position":{"edit":{"label":"Position","description":"","placeholder":"","visible":true,"editable":true,"mainField":"name"},"list":{"label":"Position","searchable":false,"sortable":false}},"created_at":{"edit":{"label":"Created_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Created_at","searchable":true,"sortable":true}},"updated_at":{"edit":{"label":"Updated_at","description":"","placeholder":"","visible":false,"editable":true},"list":{"label":"Updated_at","searchable":true,"sortable":true}}},"layouts":{"list":["id","username","email","confirmed"],"edit":[[{"name":"username","size":6},{"name":"email","size":6}],[{"name":"password","size":6},{"name":"confirmed","size":4}],[{"name":"blocked","size":4},{"name":"phoneNumber","size":6}]],"editRelations":["role","factory","position"]}}	object		
11	plugin_users-permissions_grant	{"email":{"enabled":true,"icon":"envelope"},"discord":{"enabled":false,"icon":"discord","key":"","secret":"","callback":"/auth/discord/callback","scope":["identify","email"]},"facebook":{"enabled":false,"icon":"facebook-square","key":"","secret":"","callback":"/auth/facebook/callback","scope":["email"]},"google":{"enabled":false,"icon":"google","key":"","secret":"","callback":"/auth/google/callback","scope":["email"]},"github":{"enabled":false,"icon":"github","key":"","secret":"","callback":"/auth/github/callback","scope":["user","user:email"]},"microsoft":{"enabled":false,"icon":"windows","key":"","secret":"","callback":"/auth/microsoft/callback","scope":["user.read"]},"twitter":{"enabled":false,"icon":"twitter","key":"","secret":"","callback":"/auth/twitter/callback"},"instagram":{"enabled":false,"icon":"instagram","key":"","secret":"","callback":"/auth/instagram/callback"},"vk":{"enabled":false,"icon":"vk","key":"","secret":"","callback":"/auth/vk/callback","scope":["email"]},"twitch":{"enabled":false,"icon":"twitch","key":"","secret":"","callback":"/auth/twitch/callback","scope":["user:read:email"]},"linkedin":{"enabled":false,"icon":"linkedin","key":"","secret":"","callback":"/auth/linkedin/callback","scope":["r_liteprofile","r_emailaddress"]},"cognito":{"enabled":false,"icon":"aws","key":"","secret":"","subdomain":"my.subdomain.com","callback":"/auth/cognito/callback","scope":["email","openid","profile"]}}	object		
20	plugin_users-permissions_email	{"reset_password":{"display":"Email.template.reset_password","icon":"sync","options":{"from":{"name":"Administration Panel","email":"no-reply@strapi.io"},"response_email":"","object":"Reset password","message":"<p>We heard that you lost your password. Sorry about that!</p>\\n\\n<p>But don’t worry! You can use the following link to reset your password:</p>\\n<p><%= URL %>?code=<%= TOKEN %></p>\\n\\n<p>Thanks.</p>"}},"email_confirmation":{"display":"Email.template.email_confirmation","icon":"check-square","options":{"from":{"name":"Administration Panel","email":"no-reply@strapi.io"},"response_email":"","object":"Account confirmation","message":"<p>Thank you for registering!</p>\\n\\n<p>You have to confirm your email address. Please click on the link below.</p>\\n\\n<p><%= URL %>?confirmation=<%= CODE %></p>\\n\\n<p>Thanks.</p>"}}}	object		
21	plugin_users-permissions_advanced	{"unique_email":true,"allow_register":true,"email_confirmation":false,"email_reset_password":null,"email_confirmation_redirection":null,"default_role":"authenticated"}	object		
\.


--
-- Data for Name: edge_node; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.edge_node (id, published_at, created_by, updated_by, created_at, updated_at, name, description, factory, rule) FROM stdin;
1	\N	1	1	2020-11-08 06:39:04.921+00	2020-11-08 06:39:04.94+00	edge_node_01	edge_node_01	1	\N
2	\N	1	1	2020-11-08 06:40:34.484+00	2020-11-08 06:40:34.511+00	edge_node_02	edge_node_02	1	\N
3	\N	1	1	2020-11-08 06:40:44.8+00	2020-11-08 06:40:44.811+00	edge_node_03	edge_node_03	1	\N
\.


--
-- Data for Name: factory; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.factory (id, name, description, published_at, created_by, updated_by, created_at, updated_at) FROM stdin;
1	factory_01	factory_01 hehe	\N	1	1	2020-11-08 06:25:03.53+00	2020-11-08 06:25:03.55+00
2	factory_02	factory_02	\N	1	1	2020-11-08 06:25:20.109+00	2020-11-08 06:25:20.132+00
\.


--
-- Data for Name: position; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public."position" (id, name, description, published_at, created_by, updated_by, created_at, updated_at) FROM stdin;
1	director 	Giám đốc nhà máy	\N	1	1	2020-11-08 06:31:24.826+00	2020-11-08 06:32:11.053+00
2	shift_leader	Trưởng ca	\N	1	1	2020-11-08 06:33:11.247+00	2020-11-08 06:33:11.272+00
3	electromechanical	Cơ điện 	\N	1	1	2020-11-08 06:36:11.097+00	2020-11-08 06:36:11.12+00
4	supervisor	Giám sát viên	\N	1	1	2020-11-08 06:36:42.122+00	2020-11-08 06:36:42.144+00
5	op	Người vận hành máy	\N	1	1	2020-11-08 06:37:21.173+00	2020-11-08 06:37:21.187+00
\.


--
-- Data for Name: rule; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.rule (id, name, condition, edge_node, published_at, created_by, updated_by, created_at, updated_at, sensor) FROM stdin;
1	sensor_01	{"max": 40, "min": 20, "unit": "độ C", "error": 50, "normal": 25, "warning": 30}	\N	\N	1	1	2020-11-08 06:56:26.842+00	2020-11-08 06:56:26.888+00	1
2	sensor_02	{"max": 40, "min": 20, "unit": "g/m³", "error": 50, "normal": 25, "warning": 30}	\N	\N	1	1	2020-11-08 06:57:29.036+00	2020-11-08 06:57:29.057+00	2
3	sensor_03	{"max": 40, "min": 20, "unit": "m", "error": 50, "normal": 25, "warning": 30}	\N	\N	1	1	2020-11-08 06:57:48.096+00	2020-11-08 06:58:55.873+00	\N
\.


--
-- Data for Name: sensor; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.sensor (id, name, description, edge_node, published_at, created_by, updated_by, created_at, updated_at, sensor_type, rule) FROM stdin;
4	sensor_04	sensor_04	2	\N	1	1	2020-11-08 06:41:49.869+00	2020-11-08 06:44:13.957+00	1	\N
7	sensor_07	sensor_07	3	\N	1	1	2020-11-08 06:42:20.278+00	2020-11-08 06:44:13.957+00	1	\N
5	sensor_05	sensor_05	2	\N	1	1	2020-11-08 06:42:00.792+00	2020-11-08 06:45:07.581+00	2	\N
8	sensor_08	sensor_08	3	\N	1	1	2020-11-08 06:42:31.338+00	2020-11-08 06:45:07.581+00	2	\N
3	sensor_03	sensor_03	1	\N	1	1	2020-11-08 06:41:40.217+00	2020-11-08 06:46:09.969+00	3	\N
6	sensor_06	sensor_06	2	\N	1	1	2020-11-08 06:42:09.996+00	2020-11-08 06:46:09.969+00	3	\N
9	sensor_09	sensor_09	3	\N	1	1	2020-11-08 06:42:40.868+00	2020-11-08 06:46:09.969+00	3	\N
1	sensor_01	sensor_01	1	\N	1	1	2020-11-08 06:41:14.489+00	2020-11-08 06:56:26.877+00	1	1
2	sensor_02	sensor_02	1	\N	1	1	2020-11-08 06:41:27.812+00	2020-11-08 06:57:29.054+00	2	2
\.


--
-- Data for Name: sensor_type; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.sensor_type (id, name, description, published_at, created_by, updated_by, created_at, updated_at) FROM stdin;
1	temperature_sensor	Cảm biến nhiệt độ	\N	1	1	2020-11-08 06:44:13.935+00	2020-11-08 06:44:13.961+00
2	humidity_sensor	Cảm biến độ ẩm	\N	1	1	2020-11-08 06:45:07.565+00	2020-11-08 06:45:07.586+00
3	proximity_sensor	Cảm biến tiệm cận	\N	1	1	2020-11-08 06:46:09.952+00	2020-11-08 06:46:09.973+00
4	height_sensor	Cảm biến chiều cao	\N	1	1	2020-11-08 06:59:43.92+00	2020-11-08 06:59:43.936+00
\.


--
-- Data for Name: shift_type; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.shift_type (id, name, status, time_in, time_out, published_at, created_by, updated_by, created_at, updated_at) FROM stdin;
2	shift_2	t	13:00:00	21:00:00	\N	1	1	2020-11-08 06:50:06.245+00	2020-11-08 06:50:06.258+00
1	shift_1	t	05:00:00	13:00:00	\N	1	1	2020-11-08 06:49:00.219+00	2020-11-08 06:50:15.537+00
3	shift_3	t	21:00:00	05:00:00	\N	1	1	2020-11-08 06:50:38.138+00	2020-11-08 06:50:38.151+00
\.


--
-- Data for Name: strapi_administrator; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.strapi_administrator (id, firstname, lastname, username, email, password, "resetPasswordToken", "registrationToken", "isActive", blocked) FROM stdin;
1	admin	admin	\N	admin@gmail.com	$2a$10$FUCUES5VXuHOjEaSD1Dkne4T1HyKspTLZD5nh1ojsnegaGFvJprK2	\N	\N	t	\N
\.


--
-- Data for Name: strapi_permission; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.strapi_permission (id, action, subject, fields, conditions, role, created_at, updated_at) FROM stdin;
3	plugins::upload.assets.download	\N	\N	[]	2	2020-11-08 05:54:35.069+00	2020-11-08 05:54:35.088+00
9	plugins::upload.assets.copy-link	\N	\N	[]	3	2020-11-08 05:54:35.211+00	2020-11-08 05:54:35.231+00
27	plugins::content-manager.collection-types.configure-view	\N	\N	[]	1	2020-11-08 05:54:35.363+00	2020-11-08 05:54:35.383+00
39	admin::marketplace.plugins.install	\N	\N	[]	1	2020-11-08 05:54:35.435+00	2020-11-08 05:54:35.457+00
50	admin::roles.read	\N	\N	[]	1	2020-11-08 05:54:35.497+00	2020-11-08 05:54:35.52+00
124	plugins::content-manager.explorer.publish	application::shift-type.shift-type	\N	[]	1	2020-11-08 06:21:31.662+00	2020-11-08 06:21:31.682+00
2	plugins::upload.assets.create	\N	\N	[]	2	2020-11-08 05:54:35.067+00	2020-11-08 05:54:35.176+00
7	plugins::upload.assets.update	\N	\N	["admin::is-creator"]	3	2020-11-08 05:54:35.21+00	2020-11-08 05:54:35.224+00
19	plugins::content-manager.explorer.delete	plugins::users-permissions.user	\N	[]	1	2020-11-08 05:54:35.298+00	2020-11-08 05:54:35.32+00
24	plugins::upload.assets.copy-link	\N	\N	[]	1	2020-11-08 05:54:35.353+00	2020-11-08 05:54:35.372+00
35	plugins::users-permissions.email-templates.read	\N	\N	[]	1	2020-11-08 05:54:35.416+00	2020-11-08 05:54:35.434+00
44	admin::webhooks.delete	\N	\N	[]	1	2020-11-08 05:54:35.473+00	2020-11-08 05:54:35.487+00
125	plugins::content-manager.explorer.delete	application::shift-type.shift-type	\N	[]	1	2020-11-08 06:21:31.664+00	2020-11-08 06:21:31.684+00
5	plugins::upload.read	\N	\N	[]	2	2020-11-08 05:54:35.069+00	2020-11-08 05:54:35.178+00
6	plugins::upload.assets.download	\N	\N	[]	3	2020-11-08 05:54:35.208+00	2020-11-08 05:54:35.222+00
14	plugins::content-type-builder.read	\N	\N	[]	1	2020-11-08 05:54:35.297+00	2020-11-08 05:54:35.312+00
21	plugins::upload.assets.update	\N	\N	[]	1	2020-11-08 05:54:35.346+00	2020-11-08 05:54:35.357+00
31	plugins::users-permissions.roles.delete	\N	\N	[]	1	2020-11-08 05:54:35.397+00	2020-11-08 05:54:35.413+00
41	admin::webhooks.create	\N	\N	[]	1	2020-11-08 05:54:35.449+00	2020-11-08 05:54:35.469+00
51	admin::roles.update	\N	\N	[]	1	2020-11-08 05:54:35.503+00	2020-11-08 05:54:35.523+00
59	plugins::content-manager.explorer.publish	application::factory.factory	\N	[]	1	2020-11-08 06:03:47.123+00	2020-11-08 06:03:47.145+00
94	plugins::content-manager.explorer.update	application::sensor-type.sensor-type	["name", "description", "sensors"]	[]	1	2020-11-08 06:13:10.169+00	2020-11-08 06:13:10.183+00
4	plugins::upload.assets.update	\N	\N	[]	2	2020-11-08 05:54:35.069+00	2020-11-08 05:54:35.181+00
8	plugins::upload.read	\N	\N	["admin::is-creator"]	3	2020-11-08 05:54:35.21+00	2020-11-08 05:54:35.227+00
23	plugins::upload.settings.read	\N	\N	[]	1	2020-11-08 05:54:35.353+00	2020-11-08 05:54:35.368+00
34	plugins::users-permissions.email-templates.update	\N	\N	[]	1	2020-11-08 05:54:35.416+00	2020-11-08 05:54:35.439+00
45	admin::users.create	\N	\N	[]	1	2020-11-08 05:54:35.474+00	2020-11-08 05:54:35.496+00
11	plugins::upload.assets.create	\N	\N	[]	1	2020-11-08 05:54:35.292+00	2020-11-08 05:54:35.32+00
29	plugins::users-permissions.roles.update	\N	\N	[]	1	2020-11-08 05:54:35.368+00	2020-11-08 05:54:35.39+00
37	plugins::users-permissions.advanced-settings.update	\N	\N	[]	1	2020-11-08 05:54:35.426+00	2020-11-08 05:54:35.446+00
48	admin::users.update	\N	\N	[]	1	2020-11-08 05:54:35.481+00	2020-11-08 05:54:35.507+00
60	plugins::content-manager.explorer.delete	application::factory.factory	\N	[]	1	2020-11-08 06:03:47.124+00	2020-11-08 06:03:47.146+00
95	plugins::content-manager.explorer.create	application::sensor-type.sensor-type	["name", "description", "sensors"]	[]	1	2020-11-08 06:13:10.169+00	2020-11-08 06:13:10.183+00
13	plugins::documentation.read	\N	\N	[]	1	2020-11-08 05:54:35.297+00	2020-11-08 05:54:35.316+00
25	plugins::content-manager.single-types.configure-view	\N	\N	[]	1	2020-11-08 05:54:35.358+00	2020-11-08 05:54:35.375+00
33	plugins::users-permissions.providers.update	\N	\N	[]	1	2020-11-08 05:54:35.415+00	2020-11-08 05:54:35.428+00
43	admin::webhooks.update	\N	\N	[]	1	2020-11-08 05:54:35.466+00	2020-11-08 05:54:35.484+00
52	admin::roles.delete	\N	\N	[]	1	2020-11-08 05:54:35.52+00	2020-11-08 05:54:35.536+00
96	plugins::content-manager.explorer.read	application::sensor-type.sensor-type	["name", "description", "sensors"]	[]	1	2020-11-08 06:13:10.169+00	2020-11-08 06:13:10.184+00
129	plugins::content-manager.explorer.update	application::shift-type.shift-type	["name", "status", "time_in", "time_out", "transactions"]	[]	1	2020-11-08 06:22:31.603+00	2020-11-08 06:22:31.614+00
12	plugins::upload.read	\N	\N	[]	1	2020-11-08 05:54:35.297+00	2020-11-08 05:54:35.321+00
26	plugins::content-manager.components.configure-layout	\N	\N	[]	1	2020-11-08 05:54:35.363+00	2020-11-08 05:54:35.38+00
36	plugins::users-permissions.advanced-settings.read	\N	\N	[]	1	2020-11-08 05:54:35.42+00	2020-11-08 05:54:35.442+00
47	admin::users.read	\N	\N	[]	1	2020-11-08 05:54:35.478+00	2020-11-08 05:54:35.503+00
62	plugins::content-manager.explorer.publish	application::edge-node.edge-node	\N	[]	1	2020-11-08 06:04:36.588+00	2020-11-08 06:04:36.606+00
130	plugins::content-manager.explorer.update	application::transaction.transaction	["users_permissions_user", "rule", "shift_type", "historys"]	[]	1	2020-11-08 06:22:31.605+00	2020-11-08 06:22:31.615+00
16	plugins::documentation.settings.update	\N	\N	[]	1	2020-11-08 05:54:35.298+00	2020-11-08 05:54:35.318+00
28	plugins::users-permissions.roles.create	\N	\N	[]	1	2020-11-08 05:54:35.365+00	2020-11-08 05:54:35.39+00
38	admin::marketplace.read	\N	\N	[]	1	2020-11-08 05:54:35.429+00	2020-11-08 05:54:35.452+00
46	admin::users.delete	\N	\N	[]	1	2020-11-08 05:54:35.484+00	2020-11-08 05:54:35.5+00
131	plugins::content-manager.explorer.read	application::transaction.transaction	["users_permissions_user", "rule", "shift_type", "historys"]	[]	1	2020-11-08 06:22:31.605+00	2020-11-08 06:22:31.621+00
17	plugins::documentation.settings.regenerate	\N	\N	[]	1	2020-11-08 05:54:35.298+00	2020-11-08 05:54:35.323+00
30	plugins::users-permissions.roles.read	\N	\N	[]	1	2020-11-08 05:54:35.368+00	2020-11-08 05:54:35.39+00
40	admin::marketplace.plugins.uninstall	\N	\N	[]	1	2020-11-08 05:54:35.435+00	2020-11-08 05:54:35.454+00
49	admin::roles.create	\N	\N	[]	1	2020-11-08 05:54:35.49+00	2020-11-08 05:54:35.507+00
132	plugins::content-manager.explorer.create	application::shift-type.shift-type	["name", "status", "time_in", "time_out", "transactions"]	[]	1	2020-11-08 06:22:31.605+00	2020-11-08 06:22:31.617+00
100	plugins::content-manager.explorer.delete	application::transaction.transaction	\N	[]	1	2020-11-08 06:14:58.771+00	2020-11-08 06:14:58.793+00
65	plugins::content-manager.explorer.delete	application::edge-node.edge-node	\N	[]	1	2020-11-08 06:04:36.589+00	2020-11-08 06:04:36.608+00
133	plugins::content-manager.explorer.read	application::shift-type.shift-type	["name", "status", "time_in", "time_out", "transactions"]	[]	1	2020-11-08 06:22:31.605+00	2020-11-08 06:22:31.617+00
101	plugins::content-manager.explorer.publish	application::transaction.transaction	\N	[]	1	2020-11-08 06:14:58.772+00	2020-11-08 06:14:58.795+00
134	plugins::content-manager.explorer.create	application::transaction.transaction	["users_permissions_user", "rule", "shift_type", "historys"]	[]	1	2020-11-08 06:22:31.605+00	2020-11-08 06:22:31.621+00
102	plugins::content-manager.explorer.read	plugins::users-permissions.user	["username", "email", "provider", "password", "resetPasswordToken", "confirmationToken", "confirmed", "blocked", "role", "phoneNumber", "factory", "position"]	[]	1	2020-11-08 06:15:59.2+00	2020-11-08 06:15:59.216+00
135	plugins::content-manager.explorer.update	application::rule.rule	["name", "condition", "sensor", "transactions"]	[]	1	2020-11-08 06:53:06.041+00	2020-11-08 06:53:06.057+00
103	plugins::content-manager.explorer.create	plugins::users-permissions.user	["username", "email", "provider", "password", "resetPasswordToken", "confirmationToken", "confirmed", "blocked", "role", "phoneNumber", "factory", "position"]	[]	1	2020-11-08 06:15:59.201+00	2020-11-08 06:15:59.214+00
138	plugins::content-manager.explorer.update	application::sensor.sensor	["name", "description", "edge_node", "sensor_type", "rule"]	[]	1	2020-11-08 06:53:06.044+00	2020-11-08 06:53:06.059+00
105	plugins::content-manager.explorer.delete	application::position.position	\N	[]	1	2020-11-08 06:15:59.203+00	2020-11-08 06:15:59.217+00
136	plugins::content-manager.explorer.read	application::sensor.sensor	["name", "description", "edge_node", "sensor_type", "rule"]	[]	1	2020-11-08 06:53:06.041+00	2020-11-08 06:53:06.06+00
104	plugins::content-manager.explorer.create	application::position.position	["name", "description", "users_permissions_users"]	[]	1	2020-11-08 06:15:59.203+00	2020-11-08 06:15:59.216+00
137	plugins::content-manager.explorer.read	application::rule.rule	["name", "condition", "sensor", "transactions"]	[]	1	2020-11-08 06:53:06.041+00	2020-11-08 06:53:06.061+00
106	plugins::content-manager.explorer.update	application::position.position	["name", "description", "users_permissions_users"]	[]	1	2020-11-08 06:15:59.204+00	2020-11-08 06:15:59.22+00
139	plugins::content-manager.explorer.create	application::rule.rule	["name", "condition", "sensor", "transactions"]	[]	1	2020-11-08 06:53:06.044+00	2020-11-08 06:53:06.062+00
72	plugins::content-manager.explorer.read	application::factory.factory	["name", "description", "edge_nodes", "users_permissions_users"]	[]	1	2020-11-08 06:09:32.725+00	2020-11-08 06:09:32.743+00
107	plugins::content-manager.explorer.read	application::position.position	["name", "description", "users_permissions_users"]	[]	1	2020-11-08 06:15:59.203+00	2020-11-08 06:15:59.227+00
140	plugins::content-manager.explorer.create	application::sensor.sensor	["name", "description", "edge_node", "sensor_type", "rule"]	[]	1	2020-11-08 06:53:06.044+00	2020-11-08 06:53:06.065+00
108	plugins::content-manager.explorer.publish	application::position.position	\N	[]	1	2020-11-08 06:15:59.204+00	2020-11-08 06:15:59.22+00
109	plugins::content-manager.explorer.update	plugins::users-permissions.user	["username", "email", "provider", "password", "resetPasswordToken", "confirmationToken", "confirmed", "blocked", "role", "phoneNumber", "factory", "position"]	[]	1	2020-11-08 06:15:59.204+00	2020-11-08 06:15:59.227+00
75	plugins::content-manager.explorer.update	application::factory.factory	["name", "description", "edge_nodes", "users_permissions_users"]	[]	1	2020-11-08 06:09:32.728+00	2020-11-08 06:09:32.747+00
110	plugins::content-manager.explorer.create	application::edge-node.edge-node	["name", "description", "factory", "sensors"]	[]	1	2020-11-08 06:17:25.598+00	2020-11-08 06:53:05.819+00
77	plugins::content-manager.explorer.create	application::factory.factory	["name", "description", "edge_nodes", "users_permissions_users"]	[]	1	2020-11-08 06:09:32.728+00	2020-11-08 06:09:32.745+00
112	plugins::content-manager.explorer.delete	application::rule.rule	\N	[]	1	2020-11-08 06:17:25.6+00	2020-11-08 06:17:25.614+00
78	plugins::content-manager.explorer.delete	application::sensor.sensor	\N	[]	1	2020-11-08 06:11:50.815+00	2020-11-08 06:11:50.834+00
116	plugins::content-manager.explorer.publish	application::rule.rule	\N	[]	1	2020-11-08 06:17:25.601+00	2020-11-08 06:17:25.619+00
80	plugins::content-manager.explorer.publish	application::sensor.sensor	\N	[]	1	2020-11-08 06:11:50.819+00	2020-11-08 06:11:50.836+00
113	plugins::content-manager.explorer.read	application::edge-node.edge-node	["name", "description", "factory", "sensors"]	[]	1	2020-11-08 06:17:25.6+00	2020-11-08 06:53:05.825+00
117	plugins::content-manager.explorer.update	application::edge-node.edge-node	["name", "description", "factory", "sensors"]	[]	1	2020-11-08 06:17:25.6+00	2020-11-08 06:53:05.825+00
87	plugins::content-manager.explorer.delete	application::sensor-type.sensor-type	\N	[]	1	2020-11-08 06:12:30.908+00	2020-11-08 06:12:30.921+00
90	plugins::content-manager.explorer.publish	application::sensor-type.sensor-type	\N	[]	1	2020-11-08 06:12:30.909+00	2020-11-08 06:12:30.924+00
1	plugins::upload.assets.copy-link	\N	\N	[]	2	2020-11-08 05:54:35.066+00	2020-11-08 05:54:35.172+00
10	plugins::upload.assets.create	\N	\N	[]	3	2020-11-08 05:54:35.211+00	2020-11-08 05:54:35.231+00
22	plugins::upload.assets.download	\N	\N	[]	1	2020-11-08 05:54:35.35+00	2020-11-08 05:54:35.362+00
32	plugins::users-permissions.providers.read	\N	\N	[]	1	2020-11-08 05:54:35.4+00	2020-11-08 05:54:35.42+00
42	admin::webhooks.read	\N	\N	[]	1	2020-11-08 05:54:35.46+00	2020-11-08 05:54:35.477+00
\.


--
-- Data for Name: strapi_role; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.strapi_role (id, name, code, description, created_at, updated_at) FROM stdin;
1	Super Admin	strapi-super-admin	Super Admins can access and manage all features and settings.	2020-11-08 05:54:34.909+00	2020-11-08 05:54:34.909+00
2	Editor	strapi-editor	Editors can manage and publish contents including those of other users.	2020-11-08 05:54:34.977+00	2020-11-08 05:54:34.977+00
3	Author	strapi-author	Authors can manage the content they have created.	2020-11-08 05:54:35.025+00	2020-11-08 05:54:35.025+00
\.


--
-- Data for Name: strapi_users_roles; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.strapi_users_roles (id, user_id, role_id) FROM stdin;
1	1	1
\.


--
-- Data for Name: strapi_webhooks; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.strapi_webhooks (id, name, url, headers, events, enabled) FROM stdin;
\.


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.transaction (id, users_permissions_user, published_at, created_by, updated_by, created_at, updated_at, rule, shift_type, historys) FROM stdin;
\.


--
-- Data for Name: upload_file; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.upload_file (id, name, "alternativeText", caption, width, height, formats, hash, ext, mime, size, url, "previewUrl", provider, provider_metadata, created_by, updated_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: upload_file_morph; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public.upload_file_morph (id, upload_file_id, related_id, related_type, field, "order") FROM stdin;
\.


--
-- Data for Name: users-permissions_permission; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public."users-permissions_permission" (id, type, controller, action, enabled, policy, role, created_by, updated_by) FROM stdin;
1	content-manager	components	findcomponent	f		1	\N	\N
2	content-manager	components	listcomponents	f		1	\N	\N
3	content-manager	contentmanager	count	f		2	\N	\N
4	content-manager	components	updatecomponent	f		1	\N	\N
9	content-manager	contentmanager	count	f		1	\N	\N
7	content-manager	contentmanager	checkuidavailability	f		1	\N	\N
8	content-manager	contentmanager	checkuidavailability	f		2	\N	\N
10	content-manager	components	updatecomponent	f		2	\N	\N
5	content-manager	components	findcomponent	f		2	\N	\N
6	content-manager	components	listcomponents	f		2	\N	\N
11	content-manager	contentmanager	create	f		1	\N	\N
13	content-manager	contentmanager	delete	f		1	\N	\N
12	content-manager	contentmanager	create	f		2	\N	\N
14	content-manager	contentmanager	delete	f		2	\N	\N
15	content-manager	contentmanager	deletemany	f		1	\N	\N
16	content-manager	contentmanager	deletemany	f		2	\N	\N
17	content-manager	contentmanager	find	f		1	\N	\N
18	content-manager	contentmanager	find	f		2	\N	\N
19	content-manager	contentmanager	findone	f		1	\N	\N
20	content-manager	contentmanager	findone	f		2	\N	\N
21	content-manager	contentmanager	findrelationlist	f		1	\N	\N
23	content-manager	contentmanager	generateuid	f		1	\N	\N
22	content-manager	contentmanager	findrelationlist	f		2	\N	\N
24	content-manager	contentmanager	generateuid	f		2	\N	\N
25	content-manager	contentmanager	publish	f		1	\N	\N
26	content-manager	contentmanager	publish	f		2	\N	\N
27	content-manager	contentmanager	unpublish	f		1	\N	\N
28	content-manager	contentmanager	update	f		1	\N	\N
30	content-manager	contentmanager	update	f		2	\N	\N
29	content-manager	contentmanager	unpublish	f		2	\N	\N
31	content-manager	contenttypes	findcontenttype	f		1	\N	\N
32	content-manager	contenttypes	findcontenttype	f		2	\N	\N
33	content-manager	contenttypes	listcontenttypes	f		1	\N	\N
34	content-manager	contenttypes	listcontenttypes	f		2	\N	\N
36	content-manager	contenttypes	updatecontenttype	f		1	\N	\N
35	content-manager	contenttypes	updatecontenttype	f		2	\N	\N
38	content-type-builder	builder	getreservednames	f		1	\N	\N
37	content-type-builder	builder	getreservednames	f		2	\N	\N
39	content-type-builder	componentcategories	deletecategory	f		1	\N	\N
40	content-type-builder	componentcategories	deletecategory	f		2	\N	\N
41	content-type-builder	componentcategories	editcategory	f		1	\N	\N
42	content-type-builder	componentcategories	editcategory	f		2	\N	\N
43	content-type-builder	components	createcomponent	f		1	\N	\N
44	content-type-builder	components	createcomponent	f		2	\N	\N
45	content-type-builder	components	deletecomponent	f		1	\N	\N
46	content-type-builder	components	deletecomponent	f		2	\N	\N
47	content-type-builder	components	getcomponent	f		1	\N	\N
48	content-type-builder	components	getcomponents	f		1	\N	\N
49	content-type-builder	components	getcomponent	f		2	\N	\N
50	content-type-builder	components	getcomponents	f		2	\N	\N
51	content-type-builder	components	updatecomponent	f		1	\N	\N
52	content-type-builder	components	updatecomponent	f		2	\N	\N
161	application	factory	find	f		2	\N	\N
53	content-type-builder	connections	getconnections	f		1	\N	\N
54	content-type-builder	connections	getconnections	f		2	\N	\N
55	content-type-builder	contenttypes	createcontenttype	f		1	\N	\N
56	content-type-builder	contenttypes	createcontenttype	f		2	\N	\N
58	content-type-builder	contenttypes	deletecontenttype	f		2	\N	\N
57	content-type-builder	contenttypes	deletecontenttype	f		1	\N	\N
68	documentation	documentation	getinfos	f		2	\N	\N
78	documentation	documentation	updatesettings	f		2	\N	\N
86	upload	upload	find	f		2	\N	\N
96	upload	upload	upload	f		2	\N	\N
106	users-permissions	auth	register	t		2	\N	\N
118	users-permissions	user	destroy	f		2	\N	\N
128	users-permissions	userspermissions	createrole	f		2	\N	\N
138	users-permissions	userspermissions	getpolicies	f		2	\N	\N
148	users-permissions	userspermissions	index	f		2	\N	\N
158	users-permissions	userspermissions	updaterole	f		2	\N	\N
169	application	factory	update	f		2	\N	\N
183	application	sensor	find	f		1	\N	\N
193	application	sensor	update	f		1	\N	\N
212	application	transaction	find	f		1	\N	\N
240	application	rule	findone	f		2	\N	\N
59	content-type-builder	contenttypes	getcontenttype	f		1	\N	\N
62	content-type-builder	contenttypes	getcontenttypes	f		2	\N	\N
71	documentation	documentation	login	f		1	\N	\N
72	documentation	documentation	login	f		2	\N	\N
82	upload	upload	count	f		1	\N	\N
83	upload	upload	destroy	f		1	\N	\N
94	upload	upload	updatesettings	f		2	\N	\N
93	upload	upload	updatesettings	f		1	\N	\N
103	users-permissions	auth	emailconfirmation	t		2	\N	\N
104	users-permissions	auth	forgotpassword	t		2	\N	\N
113	users-permissions	user	create	f		1	\N	\N
114	users-permissions	user	create	f		2	\N	\N
122	users-permissions	user	findone	f		2	\N	\N
124	users-permissions	user	me	t		2	\N	\N
131	users-permissions	userspermissions	getadvancedsettings	f		2	\N	\N
134	users-permissions	userspermissions	getemailtemplate	f		2	\N	\N
141	users-permissions	userspermissions	getrole	f		1	\N	\N
144	users-permissions	userspermissions	getroles	f		2	\N	\N
152	users-permissions	userspermissions	updateadvancedsettings	f		1	\N	\N
154	users-permissions	userspermissions	updateemailtemplate	f		2	\N	\N
166	application	factory	find	f		1	\N	\N
187	application	sensor	delete	f		1	\N	\N
215	application	transaction	findone	f		1	\N	\N
239	application	rule	find	f		2	\N	\N
63	content-type-builder	contenttypes	updatecontenttype	f		1	\N	\N
64	content-type-builder	contenttypes	updatecontenttype	f		2	\N	\N
73	documentation	documentation	loginview	f		1	\N	\N
74	documentation	documentation	loginview	f		2	\N	\N
81	upload	upload	count	f		2	\N	\N
85	upload	upload	find	f		1	\N	\N
90	upload	upload	getsettings	f		2	\N	\N
92	upload	upload	search	f		2	\N	\N
100	users-permissions	auth	connect	t		2	\N	\N
102	users-permissions	auth	forgotpassword	f		1	\N	\N
110	users-permissions	auth	sendemailconfirmation	f		2	\N	\N
112	users-permissions	user	count	f		2	\N	\N
120	users-permissions	user	find	f		2	\N	\N
123	users-permissions	user	me	t		1	\N	\N
129	users-permissions	userspermissions	deleterole	f		1	\N	\N
133	users-permissions	userspermissions	getemailtemplate	f		1	\N	\N
140	users-permissions	userspermissions	getproviders	f		2	\N	\N
143	users-permissions	userspermissions	getroles	f		1	\N	\N
149	users-permissions	userspermissions	searchusers	f		2	\N	\N
153	users-permissions	userspermissions	updateemailtemplate	f		1	\N	\N
167	application	factory	delete	f		2	\N	\N
186	application	sensor	count	f		2	\N	\N
213	application	transaction	find	f		2	\N	\N
232	application	rule	create	f		1	\N	\N
61	content-type-builder	contenttypes	getcontenttypes	f		1	\N	\N
65	documentation	documentation	deletedoc	f		1	\N	\N
69	documentation	documentation	index	f		1	\N	\N
77	documentation	documentation	updatesettings	f		1	\N	\N
79	email	email	send	f		1	\N	\N
88	upload	upload	findone	f		2	\N	\N
89	upload	upload	getsettings	f		1	\N	\N
98	users-permissions	auth	callback	t		2	\N	\N
99	users-permissions	auth	connect	t		1	\N	\N
108	users-permissions	auth	resetpassword	t		2	\N	\N
109	users-permissions	auth	sendemailconfirmation	f		1	\N	\N
117	users-permissions	user	destroyall	f		2	\N	\N
119	users-permissions	user	find	f		1	\N	\N
127	users-permissions	userspermissions	createrole	f		1	\N	\N
130	users-permissions	userspermissions	deleterole	f		2	\N	\N
137	users-permissions	userspermissions	getpolicies	f		1	\N	\N
139	users-permissions	userspermissions	getproviders	f		1	\N	\N
147	users-permissions	userspermissions	index	f		1	\N	\N
150	users-permissions	userspermissions	searchusers	f		1	\N	\N
157	users-permissions	userspermissions	updaterole	f		1	\N	\N
160	application	factory	create	f		1	\N	\N
170	application	factory	update	f		1	\N	\N
189	application	sensor	find	f		2	\N	\N
214	application	transaction	delete	f		1	\N	\N
238	application	rule	create	f		2	\N	\N
66	documentation	documentation	deletedoc	f		2	\N	\N
75	documentation	documentation	regeneratedoc	f		1	\N	\N
84	upload	upload	destroy	f		2	\N	\N
95	upload	upload	upload	f		1	\N	\N
105	users-permissions	auth	register	f		1	\N	\N
115	users-permissions	user	destroy	f		1	\N	\N
125	users-permissions	user	update	f		1	\N	\N
135	users-permissions	userspermissions	getpermissions	f		1	\N	\N
145	users-permissions	userspermissions	getroutes	f		1	\N	\N
155	users-permissions	userspermissions	updateproviders	f		1	\N	\N
159	application	factory	count	f		2	\N	\N
190	application	sensor	delete	f		2	\N	\N
208	application	transaction	count	f		2	\N	\N
245	application	shift-type	find	f		2	\N	\N
67	documentation	documentation	getinfos	f		1	\N	\N
76	documentation	documentation	regeneratedoc	f		2	\N	\N
87	upload	upload	findone	f		1	\N	\N
97	users-permissions	auth	callback	f		1	\N	\N
107	users-permissions	auth	resetpassword	f		1	\N	\N
116	users-permissions	user	destroyall	f		1	\N	\N
126	users-permissions	user	update	f		2	\N	\N
136	users-permissions	userspermissions	getpermissions	f		2	\N	\N
146	users-permissions	userspermissions	getroutes	f		2	\N	\N
156	users-permissions	userspermissions	updateproviders	f		2	\N	\N
168	application	factory	create	f		2	\N	\N
192	application	sensor	findone	f		2	\N	\N
216	application	transaction	findone	f		2	\N	\N
246	application	shift-type	delete	f		2	\N	\N
253	application	shift-type	update	f		1	\N	\N
164	application	factory	findone	f		1	\N	\N
191	application	sensor	findone	f		1	\N	\N
221	application	position	findone	f		2	\N	\N
243	application	shift-type	count	f		1	\N	\N
254	application	shift-type	update	f		2	\N	\N
162	application	factory	findone	f		2	\N	\N
188	application	sensor	count	f		1	\N	\N
224	application	position	create	f		2	\N	\N
229	application	position	update	f		1	\N	\N
248	application	shift-type	findone	f		1	\N	\N
165	application	factory	delete	f		1	\N	\N
195	application	sensor-type	count	f		1	\N	\N
205	application	sensor-type	update	f		1	\N	\N
219	application	position	delete	f		1	\N	\N
244	application	shift-type	findone	f		2	\N	\N
163	application	factory	count	f		1	\N	\N
199	application	sensor-type	create	f		2	\N	\N
220	application	position	count	f		2	\N	\N
247	application	shift-type	create	f		1	\N	\N
171	application	edge-node	find	f		1	\N	\N
182	application	edge-node	update	f		2	\N	\N
200	application	sensor-type	create	f		1	\N	\N
206	application	sensor-type	update	f		2	\N	\N
228	application	position	count	f		1	\N	\N
249	application	shift-type	find	f		1	\N	\N
172	application	edge-node	count	f		2	\N	\N
181	application	edge-node	update	f		1	\N	\N
203	application	sensor-type	delete	f		2	\N	\N
223	application	position	create	f		1	\N	\N
252	application	shift-type	create	f		2	\N	\N
173	application	edge-node	delete	f		2	\N	\N
196	application	sensor-type	findone	f		2	\N	\N
227	application	position	delete	f		2	\N	\N
250	application	shift-type	count	f		2	\N	\N
176	application	edge-node	findone	f		2	\N	\N
198	application	sensor-type	count	f		2	\N	\N
225	application	position	find	f		2	\N	\N
251	application	shift-type	delete	f		1	\N	\N
175	application	edge-node	find	f		2	\N	\N
201	application	sensor-type	find	f		2	\N	\N
222	application	position	findone	f		1	\N	\N
230	application	position	update	f		2	\N	\N
177	application	edge-node	delete	f		1	\N	\N
204	application	sensor-type	findone	f		1	\N	\N
226	application	position	find	f		1	\N	\N
174	application	edge-node	create	f		1	\N	\N
202	application	sensor-type	find	f		1	\N	\N
235	application	rule	find	f		1	\N	\N
241	application	rule	update	f		2	\N	\N
178	application	edge-node	findone	f		1	\N	\N
197	application	sensor-type	delete	f		1	\N	\N
237	application	rule	delete	f		1	\N	\N
242	application	rule	update	f		1	\N	\N
179	application	edge-node	create	f		2	\N	\N
207	application	transaction	count	f		1	\N	\N
234	application	rule	count	f		2	\N	\N
180	application	edge-node	count	f		1	\N	\N
209	application	transaction	create	f		1	\N	\N
217	application	transaction	update	f		1	\N	\N
231	application	rule	count	f		1	\N	\N
184	application	sensor	create	f		2	\N	\N
194	application	sensor	update	f		2	\N	\N
210	application	transaction	create	f		2	\N	\N
218	application	transaction	update	f		2	\N	\N
233	application	rule	findone	f		1	\N	\N
60	content-type-builder	contenttypes	getcontenttype	f		2	\N	\N
70	documentation	documentation	index	f		2	\N	\N
80	email	email	send	f		2	\N	\N
91	upload	upload	search	f		1	\N	\N
101	users-permissions	auth	emailconfirmation	f		1	\N	\N
111	users-permissions	user	count	f		1	\N	\N
121	users-permissions	user	findone	f		1	\N	\N
132	users-permissions	userspermissions	getadvancedsettings	f		1	\N	\N
142	users-permissions	userspermissions	getrole	f		2	\N	\N
151	users-permissions	userspermissions	updateadvancedsettings	f		2	\N	\N
185	application	sensor	create	f		1	\N	\N
211	application	transaction	delete	f		2	\N	\N
236	application	rule	delete	f		2	\N	\N
\.


--
-- Data for Name: users-permissions_role; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public."users-permissions_role" (id, name, description, type, created_by, updated_by) FROM stdin;
1	Authenticated	Default role given to authenticated user.	authenticated	\N	\N
2	Public	Default role given to unauthenticated user.	public	\N	\N
\.


--
-- Data for Name: users-permissions_user; Type: TABLE DATA; Schema: public; Owner: catalog
--

COPY public."users-permissions_user" (id, username, email, provider, password, "resetPasswordToken", "confirmationToken", confirmed, blocked, role, created_by, updated_by, created_at, updated_at, "phoneNumber", factory, "position") FROM stdin;
2	Tuan Tran	thtuan.sdh19@hcmut.edu.vn	local	$2a$10$edINvAJYKsxlsir3Or72Fukr7UWD.rLoGIPZuHBTkts83way17nTy	\N	\N	t	f	1	1	1	2020-11-08 06:27:38.974+00	2020-11-08 06:31:52.829+00	1234567890	1	1
3	Tinh Nguyen	nttinh.sdh19@hcmut.edu.vn	local	$2a$10$6SYJQVg2WZ6QNqwmBWOo9O6LXEVzl2aU7bwiVshvZ/RHPGT9f.pe.	\N	\N	t	f	1	1	1	2020-11-08 06:28:23.482+00	2020-11-08 06:33:11.268+00	1234567890	1	2
4	Duong Nguyen	nlnduong.sdh19@hcmut.edu.vn	local	$2a$10$cZKqJMV7/K4lhlHje5sLKeDUqAmFNe0ruIZicB2ZuZCs8B3UfjVFS	\N	\N	t	f	1	1	1	2020-11-08 06:28:55.575+00	2020-11-08 06:36:11.116+00	1234567890	1	3
1	Hung Pham	pdnhung.sdh19@hcmut.edu.vn	local	$2a$10$8P8LrsZmEASYuPgAOGhSQeiuHpkibHnUsaJt3ZLbvHjzqIstRxz7K	\N	\N	t	f	1	1	1	2020-11-08 06:26:29.139+00	2020-11-08 06:36:42.139+00	1234567890	1	4
5	Khang Doan	dtkhang.sdh19@hcmut.edu.vn	local	$2a$10$cx57ukK5CjRSpGre23chAOqS6CBwaoO2U.UZPZeE6bwUkaQBWU7Sy	\N	\N	t	f	1	1	1	2020-11-08 06:38:01.853+00	2020-11-08 06:38:01.863+00	1234567890	1	5
\.


--
-- Name: core_store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.core_store_id_seq', 37, true);


--
-- Name: edge_node_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.edge_node_id_seq', 3, true);


--
-- Name: factory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.factory_id_seq', 2, true);


--
-- Name: position_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.position_id_seq', 5, true);


--
-- Name: rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.rule_id_seq', 3, true);


--
-- Name: sensor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.sensor_id_seq', 9, true);


--
-- Name: sensor_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.sensor_type_id_seq', 4, true);


--
-- Name: shift_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.shift_type_id_seq', 3, true);


--
-- Name: strapi_administrator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.strapi_administrator_id_seq', 1, true);


--
-- Name: strapi_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.strapi_permission_id_seq', 140, true);


--
-- Name: strapi_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.strapi_role_id_seq', 3, true);


--
-- Name: strapi_users_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.strapi_users_roles_id_seq', 1, true);


--
-- Name: strapi_webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.strapi_webhooks_id_seq', 1, false);


--
-- Name: transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.transaction_id_seq', 1, false);


--
-- Name: upload_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.upload_file_id_seq', 1, false);


--
-- Name: upload_file_morph_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public.upload_file_morph_id_seq', 1, false);


--
-- Name: users-permissions_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public."users-permissions_permission_id_seq"', 254, true);


--
-- Name: users-permissions_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public."users-permissions_role_id_seq"', 2, true);


--
-- Name: users-permissions_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: catalog
--

SELECT pg_catalog.setval('public."users-permissions_user_id_seq"', 5, true);


--
-- Name: core_store core_store_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.core_store
    ADD CONSTRAINT core_store_pkey PRIMARY KEY (id);


--
-- Name: edge_node edge_node_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.edge_node
    ADD CONSTRAINT edge_node_pkey PRIMARY KEY (id);


--
-- Name: factory factory_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.factory
    ADD CONSTRAINT factory_pkey PRIMARY KEY (id);


--
-- Name: position position_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (id);


--
-- Name: rule rule_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.rule
    ADD CONSTRAINT rule_pkey PRIMARY KEY (id);


--
-- Name: sensor sensor_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT sensor_pkey PRIMARY KEY (id);


--
-- Name: sensor_type sensor_type_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.sensor_type
    ADD CONSTRAINT sensor_type_pkey PRIMARY KEY (id);


--
-- Name: shift_type shift_type_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.shift_type
    ADD CONSTRAINT shift_type_pkey PRIMARY KEY (id);


--
-- Name: strapi_administrator strapi_administrator_email_unique; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_administrator
    ADD CONSTRAINT strapi_administrator_email_unique UNIQUE (email);


--
-- Name: strapi_administrator strapi_administrator_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_administrator
    ADD CONSTRAINT strapi_administrator_pkey PRIMARY KEY (id);


--
-- Name: strapi_permission strapi_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_permission
    ADD CONSTRAINT strapi_permission_pkey PRIMARY KEY (id);


--
-- Name: strapi_role strapi_role_code_unique; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_role
    ADD CONSTRAINT strapi_role_code_unique UNIQUE (code);


--
-- Name: strapi_role strapi_role_name_unique; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_role
    ADD CONSTRAINT strapi_role_name_unique UNIQUE (name);


--
-- Name: strapi_role strapi_role_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_role
    ADD CONSTRAINT strapi_role_pkey PRIMARY KEY (id);


--
-- Name: strapi_users_roles strapi_users_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_users_roles
    ADD CONSTRAINT strapi_users_roles_pkey PRIMARY KEY (id);


--
-- Name: strapi_webhooks strapi_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.strapi_webhooks
    ADD CONSTRAINT strapi_webhooks_pkey PRIMARY KEY (id);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- Name: upload_file_morph upload_file_morph_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.upload_file_morph
    ADD CONSTRAINT upload_file_morph_pkey PRIMARY KEY (id);


--
-- Name: upload_file upload_file_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public.upload_file
    ADD CONSTRAINT upload_file_pkey PRIMARY KEY (id);


--
-- Name: users-permissions_permission users-permissions_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public."users-permissions_permission"
    ADD CONSTRAINT "users-permissions_permission_pkey" PRIMARY KEY (id);


--
-- Name: users-permissions_role users-permissions_role_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public."users-permissions_role"
    ADD CONSTRAINT "users-permissions_role_pkey" PRIMARY KEY (id);


--
-- Name: users-permissions_role users-permissions_role_type_unique; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public."users-permissions_role"
    ADD CONSTRAINT "users-permissions_role_type_unique" UNIQUE (type);


--
-- Name: users-permissions_user users-permissions_user_pkey; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public."users-permissions_user"
    ADD CONSTRAINT "users-permissions_user_pkey" PRIMARY KEY (id);


--
-- Name: users-permissions_user users-permissions_user_username_unique; Type: CONSTRAINT; Schema: public; Owner: catalog
--

ALTER TABLE ONLY public."users-permissions_user"
    ADD CONSTRAINT "users-permissions_user_username_unique" UNIQUE (username);


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0 (Debian 13.0-1.pgdg100+1)
-- Dumped by pg_dump version 13.0 (Debian 13.0-1.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: catalog
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO catalog;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: catalog
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

