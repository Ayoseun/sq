--
-- PostgreSQL database dump
--

-- Dumped from database version 12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 15.2 (Ubuntu 15.2-1.pgdg22.04+1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: partner_apikeys_status_enum; Type: TYPE; Schema: public; Owner: remitv
--

CREATE TYPE public.partner_apikeys_status_enum AS ENUM (
    'REVOKED',
    'ACTIVE'
);


ALTER TYPE public.partner_apikeys_status_enum OWNER TO remitv;

--
-- Name: partners_status_enum; Type: TYPE; Schema: public; Owner: remitv
--

CREATE TYPE public.partners_status_enum AS ENUM (
    'PENDING',
    'PROCESSING',
    'ACTIVE',
    'DECLINED',
    'BLOCKED'
);


ALTER TYPE public.partners_status_enum OWNER TO remitv;

--
-- Name: request_logs_enviornment_enum; Type: TYPE; Schema: public; Owner: remitv
--

CREATE TYPE public.request_logs_enviornment_enum AS ENUM (
    'SANDBOX',
    'LIVE'
);


ALTER TYPE public.request_logs_enviornment_enum OWNER TO remitv;

--
-- Name: wallets_status_enum; Type: TYPE; Schema: public; Owner: remitv
--

CREATE TYPE public.wallets_status_enum AS ENUM (
    'PENDING',
    'ACTIVE',
    'BLOCKED'
);


ALTER TYPE public.wallets_status_enum OWNER TO remitv;

--
-- Name: wallets_wallet_type_enum; Type: TYPE; Schema: public; Owner: remitv
--

CREATE TYPE public.wallets_wallet_type_enum AS ENUM (
    'CUSTOMER',
    'MASTER'
);


ALTER TYPE public.wallets_wallet_type_enum OWNER TO remitv;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: partner_apikeys; Type: TABLE; Schema: public; Owner: remitv
--

CREATE TABLE public.partner_apikeys (
    id integer NOT NULL,
    partner_id integer NOT NULL,
    sandbox_mode boolean DEFAULT true NOT NULL,
    live_mode boolean DEFAULT false NOT NULL,
    key_name character varying NOT NULL,
    api_key character varying NOT NULL,
    api_secret character varying NOT NULL,
    whitelisted_ips character varying,
    rate_limit integer DEFAULT 60 NOT NULL,
    status public.partner_apikeys_status_enum DEFAULT 'ACTIVE'::public.partner_apikeys_status_enum NOT NULL,
    created_at timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone NOT NULL,
    updated_at timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone NOT NULL
);


ALTER TABLE public.partner_apikeys OWNER TO remitv;

--
-- Name: partner_apikeys_id_seq; Type: SEQUENCE; Schema: public; Owner: remitv
--

CREATE SEQUENCE public.partner_apikeys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partner_apikeys_id_seq OWNER TO remitv;

--
-- Name: partner_apikeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: remitv
--

ALTER SEQUENCE public.partner_apikeys_id_seq OWNED BY public.partner_apikeys.id;


--
-- Name: partners; Type: TABLE; Schema: public; Owner: remitv
--

CREATE TABLE public.partners (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    country_code character varying NOT NULL,
    mobile character varying NOT NULL,
    gender character varying,
    status public.partners_status_enum DEFAULT 'PENDING'::public.partners_status_enum NOT NULL,
    created_at timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone NOT NULL,
    updated_at timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone NOT NULL
);


ALTER TABLE public.partners OWNER TO remitv;

--
-- Name: partners_id_seq; Type: SEQUENCE; Schema: public; Owner: remitv
--

CREATE SEQUENCE public.partners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partners_id_seq OWNER TO remitv;

--
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: remitv
--

ALTER SEQUENCE public.partners_id_seq OWNED BY public.partners.id;


--
-- Name: refresh_token; Type: TABLE; Schema: public; Owner: remitv
--

CREATE TABLE public.refresh_token (
    id integer NOT NULL,
    api_key character varying NOT NULL,
    token character varying NOT NULL,
    expiry_at timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone NOT NULL
);


ALTER TABLE public.refresh_token OWNER TO remitv;

--
-- Name: refresh_token_id_seq; Type: SEQUENCE; Schema: public; Owner: remitv
--

CREATE SEQUENCE public.refresh_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.refresh_token_id_seq OWNER TO remitv;

--
-- Name: refresh_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: remitv
--

ALTER SEQUENCE public.refresh_token_id_seq OWNED BY public.refresh_token.id;


--
-- Name: request_logs; Type: TABLE; Schema: public; Owner: remitv
--

CREATE TABLE public.request_logs (
    id integer NOT NULL,
    partner_id integer NOT NULL,
    wallet_id integer NOT NULL,
    request_id character varying NOT NULL,
    response_id character varying NOT NULL,
    ip_address character varying NOT NULL,
    enviornment public.request_logs_enviornment_enum DEFAULT 'SANDBOX'::public.request_logs_enviornment_enum NOT NULL,
    response_status character varying NOT NULL,
    user_agent character varying NOT NULL,
    latency character varying,
    request_body text NOT NULL,
    response_body text NOT NULL,
    created_at timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone NOT NULL,
    updated_at timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone NOT NULL
);


ALTER TABLE public.request_logs OWNER TO remitv;

--
-- Name: request_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: remitv
--

CREATE SEQUENCE public.request_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.request_logs_id_seq OWNER TO remitv;

--
-- Name: request_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: remitv
--

ALTER SEQUENCE public.request_logs_id_seq OWNED BY public.request_logs.id;


--
-- Name: wallets; Type: TABLE; Schema: public; Owner: remitv
--

CREATE TABLE public.wallets (
    id integer NOT NULL,
    partner_id integer NOT NULL,
    wallet_id character varying NOT NULL,
    remote_id character varying NOT NULL,
    wallet_public character varying NOT NULL,
    wallet_secret character varying NOT NULL,
    wallet_type public.wallets_wallet_type_enum DEFAULT 'CUSTOMER'::public.wallets_wallet_type_enum NOT NULL,
    status public.wallets_status_enum DEFAULT 'PENDING'::public.wallets_status_enum NOT NULL,
    created_at timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone NOT NULL,
    updated_at timestamp without time zone DEFAULT ('now'::text)::timestamp(6) with time zone NOT NULL
);


ALTER TABLE public.wallets OWNER TO remitv;

--
-- Name: wallets_id_seq; Type: SEQUENCE; Schema: public; Owner: remitv
--

CREATE SEQUENCE public.wallets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wallets_id_seq OWNER TO remitv;

--
-- Name: wallets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: remitv
--

ALTER SEQUENCE public.wallets_id_seq OWNED BY public.wallets.id;


--
-- Name: partner_apikeys id; Type: DEFAULT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.partner_apikeys ALTER COLUMN id SET DEFAULT nextval('public.partner_apikeys_id_seq'::regclass);


--
-- Name: partners id; Type: DEFAULT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.partners ALTER COLUMN id SET DEFAULT nextval('public.partners_id_seq'::regclass);


--
-- Name: refresh_token id; Type: DEFAULT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.refresh_token ALTER COLUMN id SET DEFAULT nextval('public.refresh_token_id_seq'::regclass);


--
-- Name: request_logs id; Type: DEFAULT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.request_logs ALTER COLUMN id SET DEFAULT nextval('public.request_logs_id_seq'::regclass);


--
-- Name: wallets id; Type: DEFAULT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.wallets ALTER COLUMN id SET DEFAULT nextval('public.wallets_id_seq'::regclass);


--
-- Data for Name: partner_apikeys; Type: TABLE DATA; Schema: public; Owner: remitv
--

COPY public.partner_apikeys (id, partner_id, sandbox_mode, live_mode, key_name, api_key, api_secret, whitelisted_ips, rate_limit, status, created_at, updated_at) FROM stdin;
1	1	t	f	Remit Tv	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	s_95c4d751-bd79-47ad-8d09-f543ba800435	64.227.138.85,85.246.151.209,148.63.78.107,3.14.176.223,18.223.18.200	60	ACTIVE	2022-09-21 05:26:08.256947	2022-09-21 05:26:08.256947
\.


--
-- Data for Name: partners; Type: TABLE DATA; Schema: public; Owner: remitv
--

COPY public.partners (id, first_name, last_name, email, password, country_code, mobile, gender, status, created_at, updated_at) FROM stdin;
1	Remit Tv	Client	demo@orokii.com	$2a$12$vntX/0rMvQGAnTLJ9k4C3OzW0HkLQEN2yJmdAw2Ruh44UYugeRnDW	US	+91900000000	M	ACTIVE	2022-09-21 05:27:53.52665	2022-09-21 05:27:53.52665
\.


--
-- Data for Name: refresh_token; Type: TABLE DATA; Schema: public; Owner: remitv
--

COPY public.refresh_token (id, api_key, token, expiry_at) FROM stdin;
20	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9cb5d229-0aaa-4394-8610-31e9cb6eb331	2022-10-02 03:36:34.275
21	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	5bff590f-c938-4002-b1a2-b982da70586c	2022-10-02 03:40:02.238
22	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	bf33b032-2655-4507-9c19-389ad62c414b	2022-10-03 13:23:27.818
23	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	0abebab2-f622-4b48-b950-615884750529	2022-10-04 13:33:02.36
24	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	91e118c3-834d-43c2-920b-b6a9f8b71881	2022-10-04 13:34:19.613
25	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	3c49d346-600e-4705-a7bf-e31ff72f497a	2022-10-04 13:44:44.693
26	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9a2a0b21-6e7f-42f2-b69a-9b95a67ac335	2022-10-04 13:46:28.92
27	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	4486d27f-4c65-411d-927a-68b0dc765284	2022-10-04 13:46:52.195
28	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f93304b6-c3bf-4efe-b890-cf25697a9ceb	2022-10-04 13:55:27.804
29	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ec412ca1-0ba5-4c0a-a40d-f8c6395fc8c5	2022-10-07 08:39:43.587
30	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	64570551-1ad3-40c2-a889-720aabb8d3c7	2022-10-07 08:50:22.853
31	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	c44daf23-0f0d-43ed-89e1-97373d0bfdb5	2022-10-22 18:37:52.851
32	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	3e223fa2-fe11-49a0-bcf4-cfd3b9dd4e96	2022-10-24 07:06:42.569
33	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a61401cb-2f0c-49be-b565-bac3df3cbcb6	2022-10-24 07:10:05.426
34	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	4a11c95a-e5cf-4ae6-b4ef-b7facadd32db	2022-11-01 17:20:09.296
36	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a6fb7fce-bd37-4696-83e5-a8e82108142c	2022-11-18 19:11:43.461
37	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	44705192-0a8b-4f68-9f1c-66dc7a302133	2022-11-28 06:22:50.669
38	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a1fd4ab0-3b64-46fc-b356-3659e6937c1b	2022-11-28 06:30:09.035
39	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e3e8799c-d2ca-4388-919f-a91737399f2f	2022-11-28 06:41:01.9
40	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e4419288-25ca-4117-b36d-aba4faded11f	2022-11-28 06:44:58.654
41	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	945725ca-c90d-4db1-945b-acf5525289ac	2022-11-28 06:50:20.879
42	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	5e509613-ceb3-42bf-907c-bc6ecf8d0d09	2022-11-28 06:59:32.557
43	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	29d9e867-38bf-4e9f-9034-6567145c4f6e	2022-11-28 07:09:45.634
44	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9bbdd115-17cd-4954-9b4c-ece77e0dc0d8	2022-12-14 11:50:14.208
45	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9f16929d-1f19-45ba-9912-10ae13cb54a6	2022-12-14 11:51:17.185
46	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	16f30698-18ba-46f4-a537-8ade1a557691	2022-12-14 11:53:39.861
47	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	2e4c4b92-6626-4244-b29b-5e953fa1e7df	2022-12-14 11:54:46.676
48	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	449ccee6-74f2-4ed5-bfef-1fd7d264bf9c	2022-12-14 11:55:01.761
49	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	49d943ea-37a0-46c8-ae2a-dd29b43d31bc	2022-12-14 12:01:42.287
50	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	54b8a986-8b9d-4fe0-aca6-65c67e6a31aa	2022-12-14 12:06:57.158
51	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9d3170f2-3f95-42fe-a282-2ec1837602e3	2022-12-14 12:10:02.171
52	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	04a8c900-d638-45ad-a34c-978c0f7d3b35	2022-12-14 12:16:59.299
53	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f09a8b37-fc9b-4f11-b38b-0673e3b7d4e7	2022-12-14 12:18:07.107
54	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	88ae7304-72cd-4fd4-a833-abe581a57e98	2022-12-14 12:20:13.289
55	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	23a09acb-b5dc-4aa4-8968-b256e9a11b4e	2022-12-14 12:20:21.279
56	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f0e82c3e-1310-4295-8221-7828791f7623	2022-12-14 12:41:29.198
57	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	5c28e79e-53d5-4cb7-9812-e49e781b9918	2022-12-14 13:03:21.625
58	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	fb166a88-79c6-4775-8a06-c9587e41141c	2022-12-14 15:28:59.071
59	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	3822fb0e-a2eb-4c5e-98da-fbab76ebae42	2022-12-15 07:43:24.298
60	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	7b1b95e1-a799-46bb-af16-89d9005b67c1	2022-12-15 12:01:16.507
61	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	fd7a6aef-44b9-43d9-bd53-982fae132f24	2022-12-15 12:01:22.863
62	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	5d8fa39a-65b3-41d6-bf14-356c4027d16f	2022-12-15 12:02:13.461
63	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e1b7391d-5dda-45e3-8a26-6329d295e5fb	2022-12-16 05:44:54.668
64	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	45c68794-073a-4f27-ab00-62e9f192b6c0	2022-12-16 05:51:40.861
65	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9cb312fd-a359-4f3c-9aed-7cd8cf9f2b02	2022-12-16 05:53:04.93
66	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ea0ca458-f2f8-4e50-bbe3-8034d5d5eff4	2022-12-16 05:53:49.714
67	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	df5fce01-148b-45e0-a1d8-1c2ccfff54cd	2022-12-19 10:26:16.692
68	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	2f1d3bbf-1ce3-4561-b607-c8e879e77b77	2022-12-19 12:08:03.764
69	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	8be494a6-53b0-41e2-97c4-559c9bfdb3c0	2022-12-19 12:22:26.234
70	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	c1cfc2ae-4f14-45e1-8778-4187fbd19978	2022-12-19 12:28:59.477
71	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f376befd-6e8c-40d6-b949-b1d377fb3995	2022-12-19 12:33:20.736
72	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ea00b206-43c0-48e8-993a-732db4147994	2022-12-19 12:43:51.894
73	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	90bef6ec-7992-40f3-85ad-4ec102c671ad	2022-12-19 14:17:50.105
74	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	70c5460d-f2e9-4f13-a0c6-a621e0e25bfd	2022-12-19 14:17:52.737
75	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	1bd190cf-518e-47f5-8a5d-b875e245ab2b	2022-12-19 14:18:00.587
76	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	7442fd74-68d1-4500-b983-514b1aa91f3d	2022-12-19 14:18:07.312
77	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	131ee4bd-24b6-46e2-abad-f9332af7769c	2022-12-19 14:25:41.098
78	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	41511de6-f7d9-4e5d-b90a-c25a848fca66	2022-12-19 14:26:01.838
79	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	34ec1714-7907-4b6f-8840-99e2e3a2ca26	2022-12-19 14:27:00.393
80	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	4a548d76-df0b-41f4-ae56-94a3e3f1663a	2022-12-19 14:28:45.843
81	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a700cbb8-0cac-483f-84a7-51729cff9aa8	2022-12-19 14:29:28.992
82	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ee963391-ac34-487c-a1fd-3078ee8d8d51	2022-12-19 14:30:22.982
83	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	36ce9541-0433-4490-abf4-760202908006	2022-12-19 14:40:27.738
84	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	2e9247a2-2a0a-4745-afc9-78d83a36db21	2022-12-19 14:44:35.838
85	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	2884c6c6-66fb-4861-9714-fc454124755c	2022-12-19 14:45:17.303
86	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	0214d7ad-2765-4196-90cb-511fe210a05c	2022-12-19 14:48:43.341
87	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a22879c2-de0b-47ac-b4c9-f689511917b0	2022-12-19 14:55:25.428
88	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	d3771d72-407c-4a4b-b598-753ae8388e0b	2022-12-19 15:10:09.736
89	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	0e9fb297-2e8c-4cf0-94b5-f41a2b7652de	2022-12-19 15:17:45.4
90	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	2d62557a-82a8-44d6-8f22-8e2cd50262d3	2022-12-19 15:18:04.596
91	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ca3ef6a3-9a5f-4341-9bb5-28647b299fe3	2022-12-19 15:18:13.026
92	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a351e1ca-3f90-4bc0-a220-43c4765d97b3	2022-12-19 15:18:19.465
93	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	4eb2afe8-0ff9-486b-ae58-35a1def550f3	2022-12-19 15:21:43.814
94	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	fe5ff2e2-d0cb-445c-b09b-57c6cac24fc5	2022-12-19 15:22:58.589
95	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	18231ceb-5a84-485e-86a2-aa1fb3084f4c	2022-12-19 16:21:16.222
96	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ac137d94-f79c-4253-b4be-b0f24dd2bb1b	2022-12-19 16:26:16.222
97	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	d51d803b-3e7a-4678-8b6c-b82c38d354b0	2022-12-19 16:27:26.135
98	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	62a3bf17-a5ff-45e3-93d3-f8d8c0836909	2022-12-19 16:30:40.959
99	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9dde4935-84b0-44a4-bc83-a91cb6b85ca5	2022-12-19 16:36:07.198
100	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a4701976-a704-4196-9a6c-ed65946742e2	2022-12-19 18:25:26.485
101	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ceb52332-3b20-4e9e-b3be-3bea8c66becc	2022-12-19 18:26:08.14
102	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	1de1f080-a9d9-4107-b4ae-bf64eef5aa89	2022-12-19 18:26:47.699
103	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	71e482d7-a5bc-49c6-9f0f-4a206968e1bf	2022-12-19 18:27:22.003
104	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	386b79fd-bf40-45c1-8199-78d5d3af251e	2022-12-19 18:28:17.054
105	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	3760e93e-482f-45a8-9a38-7b235fb02140	2022-12-19 18:29:33.056
106	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	498d3b80-7a9a-4e41-ae01-ab19bab018d2	2022-12-19 18:29:40.851
107	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	8e4921ec-f9e5-4e4c-8ed5-0278e99938a1	2022-12-19 18:44:31.099
108	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	793d15fa-1cb2-46fa-bdd2-9116c7ec6b3c	2022-12-19 19:23:35.396
109	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	fb27ce42-d91f-41e2-a994-a16019fc22da	2022-12-19 19:25:19.495
110	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a727a7fd-b3a7-4f75-a15f-185815ea58e1	2022-12-19 19:25:55.969
111	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	fd630475-cae0-47fb-88ae-90c54437428e	2022-12-19 19:26:26.172
112	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	407874c6-21c2-46e5-97aa-7bb8106021b8	2022-12-19 19:27:04.034
113	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	23aab2cf-dc44-4cba-a167-2526eca12b37	2022-12-19 19:27:24.169
114	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	bf3c16e5-f2c6-4571-9cb6-7d0ff2c4e355	2022-12-19 19:27:32.554
115	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	7c6d6bf4-4eba-4596-aca4-86452575cfca	2022-12-19 19:28:05.943
116	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	caf705b5-d373-4c4f-a109-61bad637a210	2022-12-19 19:28:20.2
117	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	fa29812a-a615-4384-9b63-29de9434b33a	2022-12-19 19:28:38.729
118	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	0e7b3d9a-8428-4dbf-aa29-7c5c9f2ca6ad	2022-12-19 19:28:50.844
119	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f697cc5e-4539-4855-bc86-fcfda415823d	2022-12-19 19:29:07.272
120	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	b33c132a-5102-41b7-a51c-f710a87130f9	2022-12-19 19:29:31.984
121	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	c4826394-2b11-4526-b5b2-d0284bcf6c4c	2022-12-19 19:29:42.978
122	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	be187206-efdf-48e3-ad76-4949e942f8a3	2022-12-19 19:32:23.337
123	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	1125d8b4-c8bd-46d4-8173-cf03ccc6a5cb	2022-12-19 19:33:42.048
124	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	906845f0-d129-4190-8930-36e8e41da72c	2022-12-19 19:36:42.553
125	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f4a43e07-11e4-4a9d-8e15-9f860b1e5b78	2022-12-19 19:38:25.527
126	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	007ed5ca-3f7f-4cd3-9c7b-1e14c803da56	2022-12-19 19:38:37.033
127	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	fb16afd1-729f-445f-b32d-c8a943e80452	2022-12-19 19:38:48.115
128	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	3579db80-bc58-444b-b75d-bf13a92cbebd	2022-12-19 19:44:04.835
129	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	0cb19993-13a7-4b7a-814e-d150498a0e65	2022-12-19 19:45:35.865
130	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	01d01007-316d-4215-aef7-5896f385ff86	2022-12-19 19:48:12.658
131	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	3e22f9a1-2423-46da-a807-9fce4064dad2	2022-12-19 19:49:46.105
132	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9a772df5-cd21-4d4f-a101-b981d76284f2	2022-12-19 19:50:30.083
133	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9f4f4244-11ff-4b5e-a1d6-1d949e9bf8ee	2022-12-19 19:50:50.734
134	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	854dc88b-2e4d-4c33-80ae-70d70b6cb6ab	2022-12-19 19:51:29.134
135	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	d5111812-dce5-4511-9d08-b762e5f307c9	2022-12-19 19:52:07.451
136	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	6bb3bda1-8d9d-4b41-aaa9-2a5e8ff65782	2022-12-26 08:56:11.111
137	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	0233deee-16d6-4b4d-92ba-86caf4f0354d	2022-12-26 08:58:47.117
138	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	934c4332-c880-450e-bef3-57482c39630a	2022-12-26 13:55:59.576
140	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	735e1fb5-487e-4d1f-9583-162e4b8913f9	2022-12-26 15:14:13.097
141	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e5a2c62b-49d9-4f51-91c3-6c7c97691b20	2023-02-02 12:36:34.487
142	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	6fca0222-5576-4871-9463-187db6b5f40a	2023-02-02 12:44:47.397
143	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	935733a7-5f4e-4e0e-99ee-28c132e4aa38	2023-02-02 12:45:55.316
144	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ed900fb1-3bb1-43c5-9e04-10c64a6b2ec5	2023-02-02 12:50:19.121
145	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e2107acb-dbd1-4563-933e-826d7aa9db2c	2023-02-02 12:50:19.335
146	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	c941c1e3-401a-4e4e-a266-8dfde7198124	2023-02-02 12:51:22.932
147	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	4756dc93-b54f-4939-b51a-ba2c9cf62adc	2023-02-02 12:51:23.153
148	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	7c408ab3-ad3d-4853-ba59-cc502f7e15f3	2023-02-02 12:51:32.611
149	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e297b12e-c18c-49ec-9bc2-95a149890543	2023-02-02 12:51:32.906
150	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	21da505c-234d-4dcc-80f0-d7ab346dd847	2023-02-02 12:53:14.173
151	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	523bac2b-8a87-4bd3-9bf3-e136ee755a6b	2023-02-02 12:53:14.416
152	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9aaf6345-e912-4d98-bbaa-0c77fd27916e	2023-02-02 12:53:46.445
153	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	7f8402b7-139b-473e-874e-48a6049f8e95	2023-02-02 12:53:46.68
154	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f31dc786-a42c-4364-b117-09cf1bd2550d	2023-02-02 12:55:41.396
155	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	63f10800-a784-48e7-baf6-5495e988918c	2023-02-02 12:55:41.6
156	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	154b379b-3f61-4939-b4a7-20f766ebceb4	2023-02-02 12:56:19.041
157	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	911c934e-926d-4c96-ba41-c9a346272bcb	2023-02-02 12:56:19.344
158	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	044ea585-78ff-400e-9401-b0831c61721a	2023-02-02 12:57:09.473
159	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	b61816fa-155f-487b-ba10-899f86525fde	2023-02-02 12:57:09.744
160	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f514b7cc-7443-448e-b27d-1f5d3d8c282c	2023-02-02 12:58:32.965
161	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	985c70b8-5552-4af8-9062-8a9c3d53cd96	2023-02-02 12:58:33.183
162	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	6301148e-8040-4c17-9a17-98856bee50fa	2023-02-02 12:58:49.426
163	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	532cdc49-b460-4197-a143-34cfa019b8a6	2023-02-02 12:58:49.648
164	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	1e099b0c-0d9e-4189-9b3f-12ad7e08e01a	2023-02-02 12:59:46.183
165	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	93ad8e65-956a-4465-9a23-aa0d0d83afc0	2023-02-02 12:59:46.387
166	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	bdc8a19d-a458-491f-9379-2ac0cdab3b30	2023-02-02 12:59:57.942
167	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	797d3937-d5d3-4270-8ae3-a10920a4e945	2023-02-02 12:59:58.18
168	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	85f0ccf4-43d9-4814-a250-91fce262dfd2	2023-02-02 13:00:55.213
169	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e9dcc2da-61c6-411b-b3d5-30c2e10044d9	2023-02-02 13:01:34.554
170	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a97e3644-db15-439d-9ee0-2f7def68f1f5	2023-02-02 13:03:18.693
171	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f712f65c-f5a6-4d5d-bd0b-455089b7de43	2023-02-02 13:03:37.268
172	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	40f4fbc2-e315-436a-b661-3fe134e320b8	2023-02-02 13:04:02.745
173	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a4672f54-3d69-4cab-9e44-38724153fa20	2023-02-02 13:04:16.271
174	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e9c977ee-4522-4b71-9324-ab7c252e75b7	2023-02-02 13:06:30.286
175	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	084da9a8-fea3-493c-8108-85b34c666c22	2023-02-02 13:06:46.422
176	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	36e9489d-c870-4a8f-b886-b6637c0c6a31	2023-02-02 13:07:25.008
177	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	56450d46-9e35-4572-b632-ca613bb8c817	2023-02-02 13:13:19.444
178	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ddfc7c8a-39ab-4ee8-85d0-2c33e44fcb50	2023-02-02 13:14:21.223
179	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	c409b6ee-1556-4663-a5ec-5b9d647f35ba	2023-02-02 13:15:36.585
180	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	c29728a9-a39b-4a5e-bef4-5122978ceb2d	2023-02-02 13:15:49.376
181	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f17a1529-c31a-4a5e-8ca7-c61d79d1a205	2023-02-02 13:20:49.768
182	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	1164ad01-be73-4a7f-8c0a-e500aa2684a0	2023-02-02 13:21:03.76
183	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	b320cb80-447c-4bee-ba7c-ddaafc61fb2a	2023-02-02 13:21:15.137
184	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e2b45779-7ba5-40eb-8264-740d0b1ab7fb	2023-02-02 13:21:28.214
185	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	67b98e9e-cc7d-4d9a-ba9e-f5746bb54413	2023-02-02 13:21:38.44
186	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ce54bc0f-dbd9-450c-ab38-8c959d933ade	2023-02-02 13:21:47.847
187	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	c3e5713f-b0c5-4291-b4a1-c315b4369e86	2023-02-02 13:21:57.201
188	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	c7d33c12-49fe-497e-936c-0520b2f46d15	2023-02-02 13:24:06.001
189	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	d3c25fa3-04fd-4b76-8499-bb37030e7be0	2023-02-02 13:25:51.311
190	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	2667799e-01de-4355-baa9-540dc0ec6756	2023-02-02 13:26:01.303
191	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	90585921-1896-42cb-aaba-4be8986a8fa5	2023-02-02 13:26:05.415
192	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	998d56fd-a49b-452f-a465-b0f744bb78a5	2023-02-02 13:26:29.098
193	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ea2a145f-bb2a-4923-b758-1ee4c65147f5	2023-02-02 13:46:46.826
194	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	4fbd90f4-e20c-4df4-b404-9897f5089c8d	2023-02-02 13:47:46.002
195	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ef47bd56-2578-477e-8ae0-ce46f06a9a68	2023-02-02 13:48:34.109
196	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	22a8ced5-721e-4d76-bfe8-739506839896	2023-02-02 13:49:46.008
197	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e2214780-9728-4339-a159-fc8e388dea7b	2023-02-02 13:51:34.526
198	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	8e611aa5-19f6-45dc-9bb6-5eeaa98a9bdd	2023-02-02 13:52:47.381
199	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	747400e7-32ce-42bd-a12d-a318f830b5c3	2023-02-02 13:53:05.641
200	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	cf358d25-c706-401e-9c5d-a8dff102c5ab	2023-02-02 13:53:36.251
201	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	12bbc589-e284-4061-a832-118834d0a8da	2023-02-02 13:54:07.463
202	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	8d683d94-453f-49dc-8a1f-7e319c9a6680	2023-02-02 13:54:38.168
203	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	2602c045-faf5-4bf0-9981-6ac01e6b8aa1	2023-02-02 13:59:56.145
204	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	671a929a-b5fd-4a23-9a76-5db9e6f707be	2023-02-02 14:03:05.893
205	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	22643291-b24f-4be0-9f4f-428810b0f78e	2023-02-02 14:03:44.82
206	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	e9b4f07a-b45d-432f-8112-f425ab96f7b3	2023-02-02 14:04:33.96
207	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	855b1ba6-cd8e-430f-8b5e-16824b4f86ec	2023-02-02 14:43:31.57
208	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	d7d4f598-a918-458e-8843-defb6524a73f	2023-02-02 14:47:41.15
209	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	3c8d7879-f0f5-4533-87a0-6ac18554afad	2023-02-02 14:48:17.796
210	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	9c7b6f08-bb44-42a6-a235-f3240cee8f0c	2023-02-02 14:48:46.815
211	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	15dbd7f6-2ff2-4b8c-a4ca-e0c3f4bb92ff	2023-02-02 14:49:29.134
212	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	b5a8f46f-91b6-49b4-b25d-0d3d258facc5	2023-02-02 15:34:05.651
213	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	8f476730-7391-4f6d-b842-943741b321d5	2023-02-02 15:35:35.169
214	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	3199d6c4-7bce-48db-b80f-dfb8a98ae6ed	2023-02-02 15:36:00.446
215	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	afa71dcd-eb14-4313-ad19-57cf684182a0	2023-02-02 15:40:39.254
216	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	d8198aa9-dbb5-4224-9138-f89902835678	2023-02-02 15:47:49.807
217	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	4b78dcd1-5231-4279-9aef-5e7cda74855f	2023-02-02 16:09:59.846
218	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a69da66a-f933-44ae-86b6-7e852171986c	2023-02-02 16:10:46.046
219	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	d1163162-510a-4e06-a087-481c973061f9	2023-02-02 16:11:01.611
220	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	8de2dd40-f677-4fda-bf12-8c83de2f679d	2023-02-02 16:11:15.944
221	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	3473a5d0-6215-4905-9067-051d55fc8831	2023-02-02 16:11:27.046
222	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	f59ed80a-55e5-4360-938f-94b5cf30576e	2023-02-07 14:12:42.915
223	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	50671cb0-762f-440d-997d-e496e5a30b2c	2023-02-07 14:17:33.081
224	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	ed6a35fd-c00f-470d-b2f2-cfc287b16c52	2023-02-09 18:09:20.462
225	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	62725c3e-e580-4657-915d-d1e2aebbace9	2023-02-09 19:06:33.236
226	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	d6d3d19c-7386-45a8-a9d9-4941473faad0	2023-02-09 19:17:31.049
227	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	6afec7e4-5bd3-49c7-a355-84bef723cd2f	2023-02-09 19:17:48.252
228	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	879f9827-04bc-42b7-9fdc-cdaa5ce91d76	2023-02-13 19:44:22.418
229	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	86caceb1-8a33-4470-8ca8-c6daa4b1b6c6	2023-02-13 19:46:56.026
230	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	bfcc5436-140b-4548-855d-1cf674c4c731	2023-02-13 20:04:13.963
231	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	a4067c77-848e-4d23-812b-19a99c17240f	2023-02-13 20:23:35.891
232	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	249e0851-44b5-4cc5-8901-604c403b2f2d	2023-02-13 20:26:25.09
233	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	09744b21-139f-4e5d-88d8-47d95e854dbb	2023-02-13 20:28:23.218
234	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	32b33f49-679f-42a9-ae69-102d43ec757d	2023-02-13 20:31:21.615
235	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	07b6b7ee-cc15-4b39-bcf0-4b3a925d72db	2023-02-13 20:33:36.461
236	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	0f96b4c8-ee68-4e59-9c32-766c9e59f466	2023-02-13 20:34:03.221
237	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	989e046c-6905-4284-81e3-b322b6c090c7	2023-02-13 20:50:26.732
238	p_f0be7178-4b61-4d85-acd0-6792e2dbd507	c264f0f0-a641-4930-9935-f54c355e648b	2023-02-13 21:09:09.053
\.


--
-- Data for Name: request_logs; Type: TABLE DATA; Schema: public; Owner: remitv
--

COPY public.request_logs (id, partner_id, wallet_id, request_id, response_id, ip_address, enviornment, response_status, user_agent, latency, request_body, response_body, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: wallets; Type: TABLE DATA; Schema: public; Owner: remitv
--

COPY public.wallets (id, partner_id, wallet_id, remote_id, wallet_public, wallet_secret, wallet_type, status, created_at, updated_at) FROM stdin;
1	1	71695260-102d-4cac-9a1b-158b480653a1	master	GCJFETJZZ4O7ZPDZ4GNFAVCMDIFFYY3LYGU2QD6LD7QY4ZP6HMFTKFGL	SCVB3Y6NM4YASWLJE2LBEVCAARG3LGEYYCEF3VLZCNO5GZ32YW3EUNLY	MASTER	ACTIVE	2022-09-21 05:53:55.953734	2022-09-21 05:53:55.953734
15	1	e48d8a9e-8dbb-4e4f-acfb-bf36e62d9732	t1	GARMHBLOEWBQIGWZVUMTKHLBQMAF2BRQFFYMAMBNW4D5OXWY7XKOROHG	SCZSYGMZRR4PX26DVL2VCQE7ONKM4K5ES22NMTZ3THG2XE2Y5MT3YWO5	CUSTOMER	ACTIVE	2022-12-16 05:21:50.042552	2022-12-16 05:21:50.042552
16	1	6dfc9cd9-e02f-41e3-99d9-6478681526f8	t2	GC5ZVG76Q7JJDH4MFSFMDIAX4VUN5SPJ6TXSFYF6HB732ASN4XISYPJJ	SDQBF2ENXZSJ4Z536KOTVHVLRYP2GOR7OQ5U2QAFCCPGWRD2HWIVNAVH	CUSTOMER	ACTIVE	2022-12-19 12:04:15.588944	2022-12-19 12:04:15.588944
17	1	1883bead-95f1-4820-8136-f3ce292cc3e9	remitTvTest123	GCBFVEBUT3D44YA7JZ25VVPNRQDDA6TM2GHLH74SDZZC6WXDKXLIPTWU	SBXXM2LMN34RH6KRWXT73AHU6Q225IG3TSP4DDOENEHM2D5ZVMNZABAO	CUSTOMER	ACTIVE	2022-12-19 16:01:20.536691	2022-12-19 16:01:20.536691
18	1	f62dd3c5-2857-4003-9a8e-709604b39045	remitTvTest	GD4XW4C7M4R3JHGSRWSVME4NLUIM3FZ4TTMUFEYZTLF6SBV2ERXU3NST	SCT74NEHMYCGVAATPVM5LYGUI24RDCWTM6WC5HMVNJ3DNKRLLQNVGLMG	CUSTOMER	ACTIVE	2022-12-19 16:02:12.617102	2022-12-19 16:02:12.617102
19	1	9a3c7836-8fc7-4311-b97c-f5346616f4e3	userWallet1	GAWC2TI4H3ODDLUZDG7RKV3AKQQUZRBR3TBMLF6V4MEUWTBB25MM7JTZ	SDSTVPJMGD66UR73SNZIGJC5BXFEEI2BMA22FMS3SMJZEZS2LD67DP23	CUSTOMER	ACTIVE	2022-12-19 16:06:48.535456	2022-12-19 16:06:48.535456
20	1	b54036e3-18ef-4727-9662-e16c226504f9	userWallet2	GB4I2CUAKMJGSVXTTS3MEH6CDEM6YXQGATHOEQRJHVSCFM6C6ELYHDAQ	SBX3Z3ZFOXSFMVWBJYIXRVF7TBQ5WDGKWXHJZVC2XZ5NTODEPSCSTPKW	CUSTOMER	ACTIVE	2022-12-19 18:14:58.35402	2022-12-19 18:14:58.35402
21	1	e52bc060-1ce8-4b8a-b29d-3513afde06e0	userWallet3	GDF3YCZZJQMMDR6AJ2V7FNUGQCLN6RALSINMY4O76P5D3JCCLGEFLJOY	SBZJEY76C5QECNJDXVBX2N6DGTC47ACB2MPM6QOMBEJDNHLOSHMWPM5X	CUSTOMER	ACTIVE	2022-12-19 18:57:32.924065	2022-12-19 18:57:32.924065
22	1	bb2a8d6b-8c10-420a-b87e-c8fff2b54d24	userWallet4	GA6ZYGIIORUOPNTLV3CW427WAGTCPZ2X4CKSIXDUJK2AG4XI5DYJ2P5F	SAYLT6X3HAHUCTHBVUETFDGPOC2I6AHRSJW43HDWVQSF4JZFTG2PZ7IL	CUSTOMER	ACTIVE	2022-12-19 18:59:07.617377	2022-12-19 18:59:07.617377
23	1	2be8af66-2ec3-4f2a-8bf8-192c93d08c18	userWallet5	GDZ2RU7GF7NINOS5XSJJ4ENYMWGJ3427TNYJ2CAOYMC42D3QJEA6ALBI	SCSYBTVKTM3SO5QKLYM2U5QJZLKQ6LH2DMKCPMGWB3ACHO6OVH6RMYV5	CUSTOMER	ACTIVE	2022-12-19 19:19:46.470653	2022-12-19 19:19:46.470653
24	1	efdcb4d3-e08c-4870-b3f2-56612b1802f1	userWallet6	GCITFB2RZBXB6SKQCYCWANPP34TJCK7VPFUILCZFWHEKR4RGV5B3THO7	SCMY6NCY74TBJMNJ3MFXPERV5DVGN3GARHYDGNJ262VBOELFIPE663G4	CUSTOMER	ACTIVE	2022-12-19 19:20:51.115479	2022-12-19 19:20:51.115479
25	1	3d0a6c19-e8f6-4cd4-930e-32f1972fbd60	userWallet7	GBVH2REQQ6H6HV64QQOSSD4JZ2GROHRJGTXQSE6T4DNBDUAMCFHTR6AI	SDZOZHCF2EQ6B3N4VKO7BEZLTRTSJ3D7TUUP5PTCKDZC6GLVLM4HRLLE	CUSTOMER	ACTIVE	2022-12-19 19:23:24.537839	2022-12-19 19:23:24.537839
26	1	cfbbdfbc-ed9a-4daa-908c-34cf419b9add	remitTvTest1	GACTWRW5VBVZT7Z6IQPDKJ2DZE2IEWABS3BABANI2HIG5Q4SDSVGOIAV	SBUPLP6T7GNMIG33GBE6YHNLBW22OQF5NUUJANCTF3UYEMG5B32TKBEH	CUSTOMER	ACTIVE	2022-12-26 14:02:25.965856	2022-12-26 14:02:25.965856
27	1	7e0404dd-31e4-4361-be7d-ea77a8fbf912	userWallet8	GBX5455BALVRAJO7HS7MR7QVYK63FQDKREGFVI6XMAWPFUIJT4OAZWUI	SAOIV3ZRK57JEM5UP2F7MWYMQT722KL2IVONUPD24T2ASGLYL7RICDAZ	CUSTOMER	ACTIVE	2023-02-02 12:51:57.536514	2023-02-02 12:51:57.536514
\.


--
-- Name: partner_apikeys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: remitv
--

SELECT pg_catalog.setval('public.partner_apikeys_id_seq', 1, true);


--
-- Name: partners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: remitv
--

SELECT pg_catalog.setval('public.partners_id_seq', 1, true);


--
-- Name: refresh_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: remitv
--

SELECT pg_catalog.setval('public.refresh_token_id_seq', 238, true);


--
-- Name: request_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: remitv
--

SELECT pg_catalog.setval('public.request_logs_id_seq', 1, false);


--
-- Name: wallets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: remitv
--

SELECT pg_catalog.setval('public.wallets_id_seq', 27, true);


--
-- Name: request_logs PK_1edd3815ae37a9b9511f5a26dca; Type: CONSTRAINT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.request_logs
    ADD CONSTRAINT "PK_1edd3815ae37a9b9511f5a26dca" PRIMARY KEY (id);


--
-- Name: wallets PK_8402e5df5a30a229380e83e4f7e; Type: CONSTRAINT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "PK_8402e5df5a30a229380e83e4f7e" PRIMARY KEY (id);


--
-- Name: partners PK_998645b20820e4ab99aeae03b41; Type: CONSTRAINT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.partners
    ADD CONSTRAINT "PK_998645b20820e4ab99aeae03b41" PRIMARY KEY (id);


--
-- Name: refresh_token PK_b575dd3c21fb0831013c909e7fe; Type: CONSTRAINT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT "PK_b575dd3c21fb0831013c909e7fe" PRIMARY KEY (id);


--
-- Name: partner_apikeys PK_eab2332577d0e0ddc102d9e4c1f; Type: CONSTRAINT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.partner_apikeys
    ADD CONSTRAINT "PK_eab2332577d0e0ddc102d9e4c1f" PRIMARY KEY (id);


--
-- Name: partners UQ_6b39bc13ab676e74eada2e744db; Type: CONSTRAINT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.partners
    ADD CONSTRAINT "UQ_6b39bc13ab676e74eada2e744db" UNIQUE (email);


--
-- Name: wallets UQ_6b5fb0bd1b19186122bf80438a9; Type: CONSTRAINT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "UQ_6b5fb0bd1b19186122bf80438a9" UNIQUE (wallet_secret);


--
-- Name: wallets UQ_7d9b5387222b4e26414af1ff8c4; Type: CONSTRAINT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "UQ_7d9b5387222b4e26414af1ff8c4" UNIQUE (wallet_public);


--
-- Name: wallets UQ_b89461d7c80d316b3e6162fa393; Type: CONSTRAINT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "UQ_b89461d7c80d316b3e6162fa393" UNIQUE (remote_id);


--
-- Name: wallets UQ_c1cf06e248522005c350032ee3b; Type: CONSTRAINT; Schema: public; Owner: remitv
--

ALTER TABLE ONLY public.wallets
    ADD CONSTRAINT "UQ_c1cf06e248522005c350032ee3b" UNIQUE (wallet_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

