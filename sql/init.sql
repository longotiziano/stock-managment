--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg120+1)
-- Dumped by pg_dump version 17.5

-- Started on 2025-08-21 01:37:40 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 867 (class 1247 OID 16386)
-- Name: movement_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.movement_type AS ENUM (
    'stock_in',
    'stock_out'
);


ALTER TYPE public.movement_type OWNER TO postgres;

--
-- TOC entry 870 (class 1247 OID 16392)
-- Name: product_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.product_type AS ENUM (
    'drink',
    'dish'
);


ALTER TYPE public.product_type OWNER TO postgres;

--
-- TOC entry 873 (class 1247 OID 16398)
-- Name: raw_material_section; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.raw_material_section AS ENUM (
    'kitchen',
    'bar'
);


ALTER TYPE public.raw_material_section OWNER TO postgres;

SET default_tablespace = '';

--
-- TOC entry 217 (class 1259 OID 16403)
-- Name: kafka_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kafka_logs (
    r_id integer NOT NULL,
    log_id integer NOT NULL,
    level text NOT NULL,
    message text NOT NULL,
    module text,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
)
PARTITION BY LIST (r_id);


ALTER TABLE public.kafka_logs OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16407)
-- Name: kafka_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kafka_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kafka_logs_log_id_seq OWNER TO postgres;

--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 218
-- Name: kafka_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kafka_logs_log_id_seq OWNED BY public.kafka_logs.log_id;


SET default_table_access_method = heap;

--
-- TOC entry 238 (class 1259 OID 17158)
-- Name: kafka_logs_global; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kafka_logs_global (
    r_id integer NOT NULL,
    log_id integer DEFAULT nextval('public.kafka_logs_log_id_seq'::regclass) NOT NULL,
    level text NOT NULL,
    message text NOT NULL,
    module text,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.kafka_logs_global OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16408)
-- Name: kafka_logs_rest1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kafka_logs_rest1 (
    r_id integer NOT NULL,
    log_id integer DEFAULT nextval('public.kafka_logs_log_id_seq'::regclass) NOT NULL,
    level text NOT NULL,
    message text NOT NULL,
    module text,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.kafka_logs_rest1 OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16415)
-- Name: kafka_logs_rest2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kafka_logs_rest2 (
    r_id integer NOT NULL,
    log_id integer DEFAULT nextval('public.kafka_logs_log_id_seq'::regclass) NOT NULL,
    level text NOT NULL,
    message text NOT NULL,
    module text,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.kafka_logs_rest2 OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16422)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    r_id integer NOT NULL,
    product_id integer NOT NULL,
    category_id integer NOT NULL,
    product_name character varying(100) NOT NULL,
    product_type public.product_type NOT NULL,
    price numeric(10,2) DEFAULT 0 NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16426)
-- Name: products_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products_categories (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    category_type public.product_type NOT NULL
);


ALTER TABLE public.products_categories OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16429)
-- Name: products_categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_categories_category_id_seq OWNER TO postgres;

--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 223
-- Name: products_categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_categories_category_id_seq OWNED BY public.products_categories.category_id;


--
-- TOC entry 224 (class 1259 OID 16430)
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;

--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 224
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- TOC entry 225 (class 1259 OID 16431)
-- Name: raw_material; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.raw_material (
    rm_id integer NOT NULL,
    rm_name character varying(100) NOT NULL,
    rm_category integer NOT NULL,
    uom character varying(10) DEFAULT 'grams'::character varying,
    r_id integer
);


ALTER TABLE public.raw_material OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16435)
-- Name: raw_material_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.raw_material_categories (
    rmc_id integer NOT NULL,
    rmc_name character varying(100) NOT NULL,
    rmc_section public.raw_material_section
);


ALTER TABLE public.raw_material_categories OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16438)
-- Name: raw_material_categories_rmc_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.raw_material_categories_rmc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.raw_material_categories_rmc_id_seq OWNER TO postgres;

--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 227
-- Name: raw_material_categories_rmc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.raw_material_categories_rmc_id_seq OWNED BY public.raw_material_categories.rmc_id;


--
-- TOC entry 228 (class 1259 OID 16439)
-- Name: raw_material_rm_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.raw_material_rm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.raw_material_rm_id_seq OWNER TO postgres;

--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 228
-- Name: raw_material_rm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.raw_material_rm_id_seq OWNED BY public.raw_material.rm_id;


--
-- TOC entry 229 (class 1259 OID 16440)
-- Name: recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipes (
    r_id integer NOT NULL,
    recipe_id integer NOT NULL,
    product_id integer NOT NULL,
    rm_id integer NOT NULL,
    rm_amount numeric(10,2) NOT NULL,
    waste numeric(5,2) DEFAULT 0
);


ALTER TABLE public.recipes OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16444)
-- Name: recipes_recipe_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipes_recipe_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recipes_recipe_id_seq OWNER TO postgres;

--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 230
-- Name: recipes_recipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipes_recipe_id_seq OWNED BY public.recipes.recipe_id;


--
-- TOC entry 231 (class 1259 OID 16445)
-- Name: restaurants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restaurants (
    r_id integer NOT NULL,
    restaurant character varying(100)
);


ALTER TABLE public.restaurants OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16448)
-- Name: restaurants_r_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.restaurants_r_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.restaurants_r_id_seq OWNER TO postgres;

--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 232
-- Name: restaurants_r_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.restaurants_r_id_seq OWNED BY public.restaurants.r_id;


--
-- TOC entry 233 (class 1259 OID 16449)
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    r_id integer NOT NULL,
    sale_id integer NOT NULL,
    product_id integer NOT NULL,
    sale_quantity numeric NOT NULL,
    sale_date timestamp without time zone DEFAULT now(),
    sale_details text
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16455)
-- Name: sales_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_sale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sales_sale_id_seq OWNER TO postgres;

--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 234
-- Name: sales_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_sale_id_seq OWNED BY public.sales.sale_id;


--
-- TOC entry 235 (class 1259 OID 16456)
-- Name: stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock (
    r_id integer NOT NULL,
    rm_id integer NOT NULL,
    stock_amount numeric DEFAULT 0 NOT NULL
);


ALTER TABLE public.stock OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16462)
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_movements (
    r_id integer NOT NULL,
    movement_id integer NOT NULL,
    rm_id integer NOT NULL,
    movement_amount numeric NOT NULL,
    movement_type public.movement_type,
    movement_date timestamp without time zone DEFAULT now(),
    movement_details text
);


ALTER TABLE public.stock_movements OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16468)
-- Name: stock_movements_movement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_movements_movement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_movements_movement_id_seq OWNER TO postgres;

--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 237
-- Name: stock_movements_movement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stock_movements_movement_id_seq OWNED BY public.stock_movements.movement_id;


--
-- TOC entry 3277 (class 0 OID 0)
-- Name: kafka_logs_global; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kafka_logs ATTACH PARTITION public.kafka_logs_global FOR VALUES IN ('-9999');


--
-- TOC entry 3275 (class 0 OID 0)
-- Name: kafka_logs_rest1; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kafka_logs ATTACH PARTITION public.kafka_logs_rest1 FOR VALUES IN (1);


--
-- TOC entry 3276 (class 0 OID 0)
-- Name: kafka_logs_rest2; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kafka_logs ATTACH PARTITION public.kafka_logs_rest2 FOR VALUES IN (2);


--
-- TOC entry 3278 (class 2604 OID 16478)
-- Name: kafka_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kafka_logs ALTER COLUMN log_id SET DEFAULT nextval('public.kafka_logs_log_id_seq'::regclass);


--
-- TOC entry 3284 (class 2604 OID 16479)
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- TOC entry 3286 (class 2604 OID 16480)
-- Name: products_categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products_categories ALTER COLUMN category_id SET DEFAULT nextval('public.products_categories_category_id_seq'::regclass);


--
-- TOC entry 3287 (class 2604 OID 16481)
-- Name: raw_material rm_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raw_material ALTER COLUMN rm_id SET DEFAULT nextval('public.raw_material_rm_id_seq'::regclass);


--
-- TOC entry 3289 (class 2604 OID 16482)
-- Name: raw_material_categories rmc_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raw_material_categories ALTER COLUMN rmc_id SET DEFAULT nextval('public.raw_material_categories_rmc_id_seq'::regclass);


--
-- TOC entry 3290 (class 2604 OID 16483)
-- Name: recipes recipe_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes ALTER COLUMN recipe_id SET DEFAULT nextval('public.recipes_recipe_id_seq'::regclass);


--
-- TOC entry 3292 (class 2604 OID 16484)
-- Name: restaurants r_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurants ALTER COLUMN r_id SET DEFAULT nextval('public.restaurants_r_id_seq'::regclass);


--
-- TOC entry 3293 (class 2604 OID 16485)
-- Name: sales sale_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales ALTER COLUMN sale_id SET DEFAULT nextval('public.sales_sale_id_seq'::regclass);


--
-- TOC entry 3296 (class 2604 OID 16486)
-- Name: stock_movements movement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_movements ALTER COLUMN movement_id SET DEFAULT nextval('public.stock_movements_movement_id_seq'::regclass);


--
-- TOC entry 3508 (class 0 OID 17158)
-- Dependencies: 238
-- Data for Name: kafka_logs_global; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kafka_logs_global (r_id, log_id, level, message, module, "timestamp") FROM stdin;
-9999	37	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 13:42:35.608409+00
-9999	42	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 13:43:03.42849+00
-9999	47	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 13:47:20.037605+00
-9999	52	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 13:48:49.274085+00
-9999	57	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 13:55:23.551707+00
-9999	58	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-19 13:55:23.614078+00
-9999	63	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 13:56:38.303278+00
-9999	64	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-19 13:56:38.419638+00
-9999	69	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 13:57:30.331201+00
-9999	70	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-19 13:57:30.390232+00
-9999	75	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 14:00:46.903291+00
-9999	76	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-19 14:00:46.964229+00
-9999	81	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 14:08:16.514253+00
-9999	82	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-19 14:08:16.569758+00
-9999	83	INFO	FinishedTask : "load_sales_task"	app.tasks.load_tasks	2025-08-19 14:08:16.675398+00
-9999	84	INFO	FinishedTask : "load_stock_movements_task"	app.tasks.load_tasks	2025-08-19 14:08:16.760018+00
-9999	89	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 22:57:08.268948+00
-9999	90	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-19 22:57:08.382793+00
-9999	91	INFO	FinishedTask : "load_weekly_rm_task"	app.tasks.load_tasks	2025-08-19 22:57:08.479514+00
-9999	92	INFO	FinishedTask : "load_stock_movements_task"	app.tasks.load_tasks	2025-08-19 22:57:08.524559+00
-9999	93	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-19 23:34:38.242291+00
-9999	98	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 23:34:38.438452+00
-9999	99	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-19 23:34:38.575891+00
-9999	100	INFO	FinishedTask : "load_weekly_rm_task"	app.tasks.load_tasks	2025-08-19 23:34:38.694736+00
-9999	101	INFO	FinishedTask : "load_stock_movements_task"	app.tasks.load_tasks	2025-08-19 23:34:38.74339+00
-9999	102	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-19 23:34:46.874059+00
-9999	107	INFO	FinishedTask : "verify_rm_task"	app.tasks.verifiers_tasks	2025-08-19 23:34:47.016515+00
-9999	108	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-19 23:34:47.080418+00
-9999	109	INFO	FinishedTask : "load_weekly_rm_task"	app.tasks.load_tasks	2025-08-19 23:34:47.176788+00
-9999	110	INFO	FinishedTask : "load_stock_movements_task"	app.tasks.load_tasks	2025-08-19 23:34:47.24055+00
-9999	111	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:01:20.629487+00
-9999	112	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:03:37.847827+00
-9999	114	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:03:38.004484+00
-9999	115	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:03:38.009429+00
-9999	116	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:03:38.04533+00
-9999	117	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:03:38.050511+00
-9999	118	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:03:38.053741+00
-9999	119	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:03:38.057565+00
-9999	120	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:03:38.059684+00
-9999	121	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-21 00:03:38.064312+00
-9999	122	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:03:38.066833+00
-9999	123	INFO	FinishedTask : "load_daily_rm_task"	app.tasks.load_tasks	2025-08-21 00:03:38.072455+00
-9999	124	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:03:38.075207+00
-9999	125	INFO	FinishedTask : "load_sales_task"	app.tasks.load_tasks	2025-08-21 00:03:38.079781+00
-9999	126	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:03:38.082098+00
-9999	127	INFO	FinishedTask : "load_stock_movements_task"	app.tasks.load_tasks	2025-08-21 00:03:38.453048+00
-9999	128	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:07:12.823064+00
-9999	130	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:07:13.022523+00
-9999	131	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:07:13.032103+00
-9999	132	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:07:13.092061+00
-9999	133	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:07:13.096622+00
-9999	134	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:07:13.100597+00
-9999	135	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:07:13.105855+00
-9999	136	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:07:13.110419+00
-9999	137	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-21 00:07:13.120367+00
-9999	138	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:07:13.123455+00
-9999	139	INFO	FinishedTask : "load_daily_rm_task"	app.tasks.load_tasks	2025-08-21 00:07:13.130512+00
-9999	140	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:07:13.133149+00
-9999	141	INFO	FinishedTask : "load_sales_task"	app.tasks.load_tasks	2025-08-21 00:07:13.139704+00
-9999	142	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:07:13.142673+00
-9999	143	INFO	FinishedTask : "load_stock_movements_task"	app.tasks.load_tasks	2025-08-21 00:07:13.225264+00
-9999	144	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:12:54.56737+00
-9999	146	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:12:54.660249+00
-9999	147	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:12:54.664216+00
-9999	148	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:12:54.689898+00
-9999	149	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:12:54.694865+00
-9999	150	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:12:54.697585+00
-9999	151	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:12:54.701478+00
-9999	152	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:12:54.704769+00
-9999	153	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-21 00:12:54.709333+00
-9999	154	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:12:54.711976+00
-9999	155	INFO	FinishedTask : "load_daily_rm_task"	app.tasks.load_tasks	2025-08-21 00:12:54.717034+00
-9999	156	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:12:54.719811+00
-9999	157	INFO	FinishedTask : "load_sales_task"	app.tasks.load_tasks	2025-08-21 00:12:54.724868+00
-9999	158	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:12:54.727235+00
-9999	159	INFO	FinishedTask : "load_stock_movements_task"	app.tasks.load_tasks	2025-08-21 00:12:54.804272+00
-9999	160	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:18:01.529816+00
-9999	162	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:18:01.636189+00
-9999	163	INFO	Started : "verify_task"	app.tasks.verifiers_tasks	2025-08-21 00:18:01.638607+00
-9999	164	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:18:01.644388+00
-9999	165	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:18:01.67038+00
-9999	166	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:18:01.676047+00
-9999	167	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:18:01.678495+00
-9999	168	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:18:01.682527+00
-9999	169	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:18:01.684591+00
-9999	170	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-21 00:18:01.691189+00
-9999	171	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:18:01.6938+00
-9999	172	INFO	FinishedTask : "load_daily_rm_task"	app.tasks.load_tasks	2025-08-21 00:18:01.699037+00
-9999	173	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:18:01.701279+00
-9999	174	INFO	FinishedTask : "load_sales_task"	app.tasks.load_tasks	2025-08-21 00:18:01.707447+00
-9999	175	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:18:01.710134+00
-9999	176	INFO	FinishedTask : "load_stock_movements_task"	app.tasks.load_tasks	2025-08-21 00:18:01.820941+00
-9999	177	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:19:14.96275+00
-9999	179	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:19:15.077574+00
-9999	180	INFO	Started : "verify_task"	app.tasks.verifiers_tasks	2025-08-21 00:19:15.080349+00
-9999	181	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:19:15.086059+00
-9999	182	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:19:15.115406+00
-9999	183	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:19:15.121838+00
-9999	184	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:19:15.12427+00
-9999	185	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:19:15.129839+00
-9999	186	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:19:15.132876+00
-9999	187	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-21 00:19:15.137979+00
-9999	188	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:19:15.140396+00
-9999	189	INFO	FinishedTask : "load_daily_rm_task"	app.tasks.load_tasks	2025-08-21 00:19:15.146637+00
-9999	190	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:19:15.149391+00
-9999	191	INFO	FinishedTask : "load_sales_task"	app.tasks.load_tasks	2025-08-21 00:19:15.155204+00
-9999	192	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:19:15.157343+00
-9999	193	INFO	FinishedTask : "load_stock_movements_task"	app.tasks.load_tasks	2025-08-21 00:19:15.256857+00
-9999	194	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:19:47.477765+00
-9999	196	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:19:47.566394+00
-9999	197	INFO	Started : "verify_task"	app.tasks.verifiers_tasks	2025-08-21 00:19:47.56928+00
-9999	200	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:19:47.642225+00
-9999	201	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:19:47.669131+00
-9999	204	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:19:47.70424+00
-9999	205	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:19:47.706422+00
-9999	206	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:21:39.787016+00
-9999	208	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:21:39.89791+00
-9999	209	INFO	Started : "verify_task"	app.tasks.verifiers_tasks	2025-08-21 00:21:39.900481+00
-9999	212	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:21:39.956893+00
-9999	213	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:21:40.009838+00
-9999	216	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:21:40.097913+00
-9999	217	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:21:40.100031+00
-9999	220	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:21:40.260932+00
-9999	221	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:21:40.26345+00
-9999	222	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:25:29.298144+00
-9999	224	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:25:29.389876+00
-9999	225	INFO	Started : "verify_task"	app.tasks.verifiers_tasks	2025-08-21 00:25:29.392021+00
-9999	228	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:25:29.440106+00
-9999	229	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:25:29.46851+00
-9999	232	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:25:29.500672+00
-9999	233	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:25:29.502692+00
-9999	236	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:25:29.632702+00
-9999	237	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:25:29.635734+00
-9999	238	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:28:03.407909+00
-9999	240	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:28:03.579832+00
-9999	241	INFO	Started : "verify_task"	app.tasks.verifiers_tasks	2025-08-21 00:28:03.585377+00
-9999	244	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:28:03.647372+00
-9999	245	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:28:03.677595+00
-9999	248	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:28:03.717466+00
-9999	249	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:28:03.720849+00
-9999	252	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:28:03.881992+00
-9999	253	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:28:03.884771+00
-9999	254	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:29:28.051578+00
-9999	257	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:29:28.158147+00
-9999	258	INFO	Started : "verify_task"	app.tasks.verifiers_tasks	2025-08-21 00:29:28.159851+00
-9999	261	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:29:28.211768+00
-9999	262	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:29:28.239059+00
-9999	265	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:29:28.27309+00
-9999	266	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:29:28.275342+00
-9999	269	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:29:28.396454+00
-9999	270	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:29:28.398748+00
-9999	271	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:37:09.325308+00
-9999	273	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:37:09.459448+00
-9999	274	INFO	Started : "verify_task"	app.tasks.verifiers_tasks	2025-08-21 00:37:09.461091+00
-9999	277	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:37:09.515671+00
-9999	278	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:37:09.5407+00
-9999	282	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:37:09.576235+00
-9999	283	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:37:09.578426+00
-9999	286	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:37:09.691756+00
-9999	287	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:37:09.693669+00
-9999	288	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:37:56.189834+00
-9999	291	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:37:56.294163+00
-9999	292	INFO	Started : "verify_task"	app.tasks.verifiers_tasks	2025-08-21 00:37:56.297406+00
-9999	295	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:37:56.332492+00
-9999	296	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:37:56.357421+00
-9999	299	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:37:56.394926+00
-9999	300	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:37:56.397307+00
-9999	303	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:37:56.542139+00
-9999	304	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:37:56.544079+00
-9999	305	INFO	Started : "csv_task"	app.tasks.extraction_tasks	2025-08-21 00:39:40.844198+00
-9999	307	INFO	FinishedTask : "random_consumption_task"	app.tasks.extraction_tasks	2025-08-21 00:39:40.944692+00
-9999	308	INFO	Started : "verify_task"	app.tasks.verifiers_tasks	2025-08-21 00:39:40.94755+00
-9999	311	INFO	FinishedTask : "verify_products_task"	app.tasks.verifiers_tasks	2025-08-21 00:39:40.982341+00
-9999	312	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:39:41.005241+00
-9999	315	INFO	FinishedTask : "products_to_sales_task"	app.tasks.conversion_tasks	2025-08-21 00:39:41.037205+00
-9999	316	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:39:41.039749+00
-9999	319	INFO	FinishedTask : "products_conversion_task"	app.tasks.conversion_tasks	2025-08-21 00:39:41.148413+00
-9999	320	INFO	Started : "processing_csv_task"	app.tasks.conversion_tasks	2025-08-21 00:39:41.150454+00
-9999	323	INFO	FinishedTask : "rm_to_stock_movements_task"	app.tasks.conversion_tasks	2025-08-21 00:39:41.184939+00
-9999	324	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:39:41.187518+00
-9999	325	INFO	FinishedTask : "load_daily_rm_task"	app.tasks.load_tasks	2025-08-21 00:39:41.330764+00
-9999	326	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:39:41.333645+00
-9999	327	INFO	FinishedTask : "load_sales_task"	app.tasks.load_tasks	2025-08-21 00:39:41.4308+00
-9999	328	INFO	Started : "load_data_task"	app.tasks.load_tasks	2025-08-21 00:39:41.432603+00
-9999	329	INFO	FinishedTask : "load_stock_movements_task"	app.tasks.load_tasks	2025-08-21 00:39:41.491458+00
\.


--
-- TOC entry 3489 (class 0 OID 16408)
-- Dependencies: 219
-- Data for Name: kafka_logs_rest1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kafka_logs_rest1 (r_id, log_id, level, message, module, "timestamp") FROM stdin;
1	1	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:38:34.998934+00
1	33	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:42:35.53724+00
1	35	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:42:35.584125+00
1	38	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:43:03.359911+00
1	40	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:43:03.407038+00
1	43	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:47:19.975393+00
1	45	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:47:20.019132+00
1	48	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:48:49.196896+00
1	50	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:48:49.252761+00
1	53	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:55:23.481715+00
1	55	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:55:23.532301+00
1	59	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:56:38.188844+00
1	61	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:56:38.266194+00
1	65	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:57:30.265471+00
1	67	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:57:30.313724+00
1	71	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 14:00:46.828606+00
1	73	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 14:00:46.885019+00
1	77	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 14:08:16.425762+00
1	79	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 14:08:16.495696+00
1	85	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 22:57:08.179754+00
1	87	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 22:57:08.249118+00
1	94	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 23:34:38.351898+00
1	96	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 23:34:38.400251+00
1	103	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 23:34:46.952482+00
1	105	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 23:34:46.99741+00
1	198	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:19:47.620273+00
1	202	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:19:47.680687+00
1	210	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:21:39.931899+00
1	214	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:21:40.066786+00
1	218	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:21:40.202287+00
1	226	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:25:29.420545+00
1	230	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:25:29.479538+00
1	234	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:25:29.561949+00
1	242	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:28:03.623391+00
1	246	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:28:03.689855+00
1	250	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:28:03.791194+00
1	255	ERROR	ExecutionError : raw_material_to_stock_movements() got an unexpected keyword argument 'assigned_direction'	app.tasks.conversion_tasks	2025-08-21 00:29:28.409186+00
1	259	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:29:28.193142+00
1	263	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:29:28.250765+00
1	267	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:29:28.33419+00
1	275	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:37:09.493087+00
1	279	ERROR	ExecutionError : raw_material_to_stock_movements() got an unexpected keyword argument 'assigned_direction'	app.tasks.conversion_tasks	2025-08-21 00:37:09.702471+00
1	280	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:37:09.552602+00
1	284	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:37:09.627614+00
1	289	ERROR	ExecutionError : raw_material_to_stock_movements() got an unexpected keyword argument 'assigned_direction'	app.tasks.conversion_tasks	2025-08-21 00:37:56.553392+00
1	293	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:37:56.320174+00
1	297	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:37:56.370777+00
1	301	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:37:56.458949+00
1	309	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:39:40.970108+00
1	313	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:39:41.01602+00
1	317	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:39:41.089938+00
1	321	INFO	FinishedConversion : "raw_material_to_stock_movements"	app.controllers.conversion	2025-08-21 00:39:41.161397+00
\.


--
-- TOC entry 3490 (class 0 OID 16415)
-- Dependencies: 220
-- Data for Name: kafka_logs_rest2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kafka_logs_rest2 (r_id, log_id, level, message, module, "timestamp") FROM stdin;
2	2	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:38:35.016864+00
2	34	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:42:35.552914+00
2	36	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:42:35.605036+00
2	39	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:43:03.375858+00
2	41	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:43:03.424978+00
2	44	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:47:19.990008+00
2	46	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:47:20.03465+00
2	49	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:48:49.216025+00
2	51	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:48:49.270426+00
2	54	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:55:23.497108+00
2	56	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:55:23.54822+00
2	60	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:56:38.210114+00
2	62	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:56:38.298249+00
2	66	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 13:57:30.281554+00
2	68	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 13:57:30.328491+00
2	72	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 14:00:46.852052+00
2	74	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 14:00:46.899822+00
2	78	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 14:08:16.451097+00
2	80	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 14:08:16.51125+00
2	86	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 22:57:08.20013+00
2	88	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 22:57:08.265651+00
2	95	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 23:34:38.363818+00
2	97	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 23:34:38.433385+00
2	104	INFO	FileCreated : "stock_addition.csv"	app.repositories.raw_material_repository	2025-08-19 23:34:46.965829+00
2	106	INFO	RawMaterialVerification : Finished	app.verifiers.raw_material_verifiers	2025-08-19 23:34:47.013597+00
2	113	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:03:38.000899+00
2	129	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:07:13.014299+00
2	145	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:12:54.65743+00
2	161	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:18:01.633516+00
2	178	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:19:15.074604+00
2	195	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:19:47.563734+00
2	199	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:19:47.638497+00
2	203	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:19:47.695272+00
2	207	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:21:39.894763+00
2	211	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:21:39.952286+00
2	215	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:21:40.089268+00
2	219	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:21:40.253158+00
2	223	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:25:29.387285+00
2	227	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:25:29.436845+00
2	231	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:25:29.492782+00
2	235	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:25:29.623618+00
2	239	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:28:03.576374+00
2	243	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:28:03.640633+00
2	247	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:28:03.708527+00
2	251	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:28:03.871894+00
2	256	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:29:28.155256+00
2	260	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:29:28.208841+00
2	264	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:29:28.264416+00
2	268	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:29:28.388109+00
2	272	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:37:09.457221+00
2	276	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:37:09.512723+00
2	281	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:37:09.566405+00
2	285	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:37:09.683821+00
2	290	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:37:56.291786+00
2	294	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:37:56.329992+00
2	298	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:37:56.385773+00
2	302	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:37:56.533958+00
2	306	INFO	FileCreated : "products_consumption.csv"	app.repositories.products_repository	2025-08-21 00:39:40.941651+00
2	310	INFO	RawMaterialVerification : Finished	app.verifiers.products_verifiers	2025-08-21 00:39:40.979889+00
2	314	INFO	FinishedConversion : "products_df_to_sales"	app.controllers.conversion	2025-08-21 00:39:41.029262+00
2	318	INFO	FinishedConversion : "products_to_raw_material_df"	app.controllers.conversion	2025-08-21 00:39:41.140928+00
2	322	INFO	FinishedConversion : "raw_material_to_stock_movements"	app.controllers.conversion	2025-08-21 00:39:41.175521+00
\.


--
-- TOC entry 3491 (class 0 OID 16422)
-- Dependencies: 221
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (r_id, product_id, category_id, product_name, product_type, price) FROM stdin;
1	1	1	garlic_bread	dish	4.50
1	2	1	bruschetta	dish	5.00
1	3	2	grilled_chicken	dish	12.00
1	4	2	beef_lasagna	dish	13.50
1	5	3	chocolate_cake	dish	6.00
1	6	3	vanilla_ice_cream	dish	4.50
1	7	4	caesar_salad	dish	7.00
1	8	4	greek_salad	dish	7.50
1	9	5	chicken_sandwich	dish	8.00
1	10	5	tuna_melt	dish	8.50
1	11	6	french_fries	dish	3.50
1	12	6	mashed_potatoes	dish	3.50
1	13	7	chicken_noodle_soup	dish	5.00
1	14	7	tomato_soup	dish	4.50
1	15	8	scrambled_eggs	dish	6.00
1	16	8	pancakes	dish	7.00
1	17	9	mineral_water	drink	2.00
1	18	9	cola	drink	2.50
1	19	10	red_wine	drink	6.50
1	20	10	craft_beer	drink	5.00
1	21	11	espresso	drink	2.50
1	22	11	green_tea	drink	2.50
1	23	12	orange_juice	drink	3.00
1	24	12	apple_juice	drink	3.00
1	25	13	mojito	drink	7.00
1	26	13	margarita	drink	7.50
1	27	14	lager_beer	drink	4.00
1	28	14	ipa_beer	drink	4.50
1	29	15	chardonnay	drink	6.50
1	30	15	malbec	drink	7.00
1	31	16	vodka_shot	drink	5.00
1	32	16	whiskey_neat	drink	6.00
2	33	1	cheese_sticks	dish	5.00
2	34	1	stuffed_mushrooms	dish	5.50
2	35	2	bbq_ribs	dish	14.00
2	36	2	vegan_burger	dish	11.50
2	37	3	cheesecake	dish	6.50
2	38	3	fruit_salad	dish	5.00
2	39	4	quinoa_salad	dish	8.00
2	40	4	chickpea_salad	dish	7.50
2	41	5	club_sandwich	dish	9.00
2	42	5	ham_and_cheese	dish	7.50
2	43	6	onion_rings	dish	4.00
2	44	6	sweet_potato_fries	dish	4.50
2	45	7	lentil_soup	dish	5.50
2	46	7	pumpkin_soup	dish	5.00
2	47	8	french_toast	dish	7.50
2	48	8	bacon_and_eggs	dish	8.00
2	49	9	lemonade	drink	3.00
2	50	9	iced_tea	drink	3.50
2	51	10	sangria	drink	6.50
2	52	10	gin_tonic	drink	7.00
2	53	11	latte	drink	3.00
2	54	11	black_tea	drink	2.50
2	55	12	pineapple_juice	drink	3.50
2	56	12	carrot_juice	drink	3.50
2	57	13	caipirinha	drink	7.00
2	58	13	bloody_mary	drink	7.50
2	59	14	stout_beer	drink	5.00
2	60	14	pale_ale	drink	4.50
2	61	15	cabernet_sauvignon	drink	7.50
2	62	15	pinot_noir	drink	7.00
2	63	16	rum_cola	drink	6.00
2	64	16	tequila_shot	drink	5.50
\.


--
-- TOC entry 3492 (class 0 OID 16426)
-- Dependencies: 222
-- Data for Name: products_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products_categories (category_id, category_name, category_type) FROM stdin;
1	starters	dish
2	main_dishes	dish
3	desserts	dish
4	salads	dish
5	sandwiches	dish
6	side_dishes	dish
7	soups	dish
8	breakfast	dish
9	non_alcoholic_drinks	drink
10	alcoholic_drinks	drink
11	coffee_tea	drink
12	juices	drink
13	cocktails	drink
14	beers	drink
15	wines	drink
16	spirits	drink
\.


--
-- TOC entry 3495 (class 0 OID 16431)
-- Dependencies: 225
-- Data for Name: raw_material; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.raw_material (rm_id, rm_name, rm_category, uom, r_id) FROM stdin;
56	bread	4	grams	2
57	garlic	7	grams	2
58	tomato	1	grams	2
59	basil	7	grams	2
60	mozzarella	3	grams	2
61	chicken_breast	2	grams	2
62	ground_beef	2	grams	2
63	lasagna_pasta	5	grams	2
64	parmesan_cheese	3	grams	2
65	chocolate	9	grams	2
66	vanilla	9	grams	2
67	flour	4	grams	2
68	sugar	9	grams	2
69	lettuce	1	grams	2
70	croutons	4	grams	2
71	caesar_dressing	6	grams	2
72	cucumber	1	grams	2
73	feta_cheese	3	grams	2
74	tuna	2	grams	2
75	ham	2	grams	2
76	cheddar_cheese	3	grams	2
77	potatoes	1	grams	2
78	butter	3	grams	2
79	onion	1	grams	2
80	sweet_potato	1	grams	2
81	lentils	5	grams	2
82	pumpkin	1	grams	2
83	bacon	2	grams	2
84	pancake_mix	4	grams	2
85	quinoa	5	grams	2
86	chickpeas	5	grams	2
87	carbonated_water	15	grams	2
88	cola_syrup	14	grams	2
89	wine_red	11	grams	2
90	wine_white	11	grams	2
91	beer_lager	12	grams	2
92	beer_ipa	12	grams	2
93	coffee_beans	17	grams	2
94	tea_black	17	grams	2
95	tea_green	17	grams	2
96	orange	16	grams	2
97	apple	16	grams	2
98	pineapple	16	grams	2
99	carrot	13	grams	2
100	mint	16	grams	2
101	lime	16	grams	2
102	sugar_syrup	18	grams	2
103	white_rum	10	grams	2
104	tequila	10	grams	2
105	vodka	10	grams	2
106	whiskey	10	grams	2
107	gin	10	grams	2
108	tonic_water	15	grams	2
109	campari	10	grams	2
110	eggs	8	units	2
1	bread	4	grams	1
2	garlic	7	grams	1
3	tomato	1	grams	1
4	basil	7	grams	1
5	mozzarella	3	grams	1
6	chicken_breast	2	grams	1
7	ground_beef	2	grams	1
8	lasagna_pasta	5	grams	1
9	parmesan_cheese	3	grams	1
10	chocolate	9	grams	1
11	vanilla	9	grams	1
12	flour	4	grams	1
13	sugar	9	grams	1
15	lettuce	1	grams	1
16	croutons	4	grams	1
17	caesar_dressing	6	grams	1
18	cucumber	1	grams	1
19	feta_cheese	3	grams	1
20	tuna	2	grams	1
21	ham	2	grams	1
22	cheddar_cheese	3	grams	1
23	potatoes	1	grams	1
24	butter	3	grams	1
25	onion	1	grams	1
26	sweet_potato	1	grams	1
27	lentils	5	grams	1
28	pumpkin	1	grams	1
29	bacon	2	grams	1
30	pancake_mix	4	grams	1
31	quinoa	5	grams	1
32	chickpeas	5	grams	1
33	carbonated_water	15	grams	1
34	cola_syrup	14	grams	1
35	wine_red	11	grams	1
36	wine_white	11	grams	1
37	beer_lager	12	grams	1
38	beer_ipa	12	grams	1
39	coffee_beans	17	grams	1
40	tea_black	17	grams	1
41	tea_green	17	grams	1
42	orange	16	grams	1
43	apple	16	grams	1
44	pineapple	16	grams	1
45	carrot	13	grams	1
46	mint	16	grams	1
47	lime	16	grams	1
48	sugar_syrup	18	grams	1
49	white_rum	10	grams	1
50	tequila	10	grams	1
51	vodka	10	grams	1
52	whiskey	10	grams	1
53	gin	10	grams	1
54	tonic_water	15	grams	1
55	campari	10	grams	1
14	eggs	8	units	1
\.


--
-- TOC entry 3496 (class 0 OID 16435)
-- Dependencies: 226
-- Data for Name: raw_material_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.raw_material_categories (rmc_id, rmc_name, rmc_section) FROM stdin;
1	vegetables	kitchen
2	meat	kitchen
3	dairy	kitchen
4	bakery	kitchen
5	grains_and_legumes	kitchen
6	condiments_and_sauces	kitchen
7	spices_and_herbs	kitchen
8	eggs	kitchen
9	sweets	kitchen
10	spirits	bar
11	wine	bar
12	beer	bar
13	juices	bar
14	soft_drinks	bar
15	mixers	bar
16	herbs_and_fruits	bar
17	coffee_and_tea	bar
18	syrups	bar
\.


--
-- TOC entry 3499 (class 0 OID 16440)
-- Dependencies: 229
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipes (r_id, recipe_id, product_id, rm_id, rm_amount, waste) FROM stdin;
1	1	1	1	60.00	0.00
1	2	1	2	10.00	0.00
1	3	1	23	15.00	0.00
1	4	2	1	40.00	0.00
1	5	2	3	30.00	0.00
1	6	2	4	5.00	0.00
1	7	2	5	20.00	0.00
1	8	3	6	150.00	0.00
1	9	3	23	10.00	0.00
1	10	3	2	5.00	0.00
1	11	4	7	120.00	0.00
1	12	4	8	80.00	0.00
1	13	4	9	20.00	0.00
1	14	4	5	40.00	0.00
1	15	5	10	50.00	0.00
1	16	5	11	5.00	0.00
1	17	5	12	100.00	0.00
1	18	5	13	50.00	0.00
1	19	5	14	2.00	0.00
1	20	6	11	5.00	0.00
1	21	6	13	40.00	0.00
1	22	6	5	60.00	0.00
1	23	6	14	1.00	0.00
1	24	7	15	40.00	0.00
1	25	7	16	20.00	0.00
1	26	7	17	30.00	0.00
1	27	7	9	10.00	0.00
1	28	8	15	40.00	0.00
1	29	8	18	30.00	0.00
1	30	8	19	20.00	0.00
1	31	8	3	20.00	0.00
1	32	9	6	100.00	0.00
1	33	9	1	60.00	0.00
1	34	9	20	20.00	0.00
1	35	9	23	10.00	0.00
1	36	10	1	60.00	0.00
1	37	10	20	80.00	0.00
1	38	10	21	30.00	0.00
1	39	11	22	150.00	0.00
1	40	11	23	10.00	0.00
1	41	12	22	180.00	0.00
1	42	12	23	15.00	0.00
1	43	12	14	1.00	0.00
1	44	13	6	80.00	0.00
1	45	13	2	5.00	0.00
1	46	13	25	50.00	0.00
1	47	13	8	40.00	0.00
1	48	14	3	100.00	0.00
1	49	14	25	30.00	0.00
1	50	14	23	10.00	0.00
1	51	14	13	10.00	0.00
1	52	15	14	3.00	0.00
1	53	15	23	10.00	0.00
1	54	15	21	20.00	0.00
1	55	16	26	100.00	0.00
1	56	16	14	2.00	0.00
1	57	16	13	30.00	0.00
1	58	16	23	10.00	0.00
1	59	17	31	250.00	0.00
1	60	18	32	200.00	0.00
1	61	18	31	150.00	0.00
1	62	19	33	200.00	0.00
1	63	20	35	200.00	0.00
1	64	21	37	10.00	0.00
1	65	22	39	5.00	0.00
1	66	22	31	200.00	0.00
1	67	23	41	150.00	0.00
1	68	24	42	150.00	0.00
1	69	25	45	50.00	0.00
1	70	25	44	10.00	0.00
1	71	25	43	20.00	0.00
1	72	25	31	100.00	0.00
1	73	26	46	50.00	0.00
1	74	26	44	10.00	0.00
1	75	26	31	50.00	0.00
1	76	26	43	10.00	0.00
1	77	27	35	250.00	0.00
1	78	28	36	250.00	0.00
1	79	29	34	200.00	0.00
1	80	30	33	200.00	0.00
1	81	31	47	50.00	0.00
1	82	32	48	50.00	0.00
2	83	33	6	120.00	0.00
2	84	33	2	5.00	0.00
2	85	33	23	10.00	0.00
2	86	34	3	30.00	0.00
2	87	34	4	5.00	0.00
2	88	34	5	20.00	0.00
2	89	35	7	150.00	0.00
2	90	35	23	10.00	0.00
2	91	36	8	100.00	0.00
2	92	36	21	30.00	0.00
2	93	36	14	1.00	0.00
2	94	36	9	20.00	0.00
2	95	37	10	60.00	0.00
2	96	37	12	100.00	0.00
2	97	37	13	50.00	0.00
2	98	37	14	2.00	0.00
2	99	38	13	60.00	0.00
2	100	38	14	3.00	0.00
2	101	38	5	50.00	0.00
2	102	39	30	60.00	0.00
2	103	39	18	30.00	0.00
2	104	39	1	20.00	0.00
2	105	40	31	70.00	0.00
2	106	40	2	5.00	0.00
2	107	40	4	5.00	0.00
2	108	41	1	60.00	0.00
2	109	41	21	30.00	0.00
2	110	41	5	10.00	0.00
2	111	42	15	30.00	0.00
2	112	42	3	30.00	0.00
2	113	42	18	30.00	0.00
2	114	43	25	100.00	0.00
2	115	43	12	80.00	0.00
2	116	43	23	10.00	0.00
2	117	44	24	120.00	0.00
2	118	44	23	10.00	0.00
2	119	45	27	100.00	0.00
2	120	45	25	30.00	0.00
2	121	45	2	5.00	0.00
2	122	46	28	100.00	0.00
2	123	46	25	30.00	0.00
2	124	46	23	10.00	0.00
2	125	47	14	2.00	0.00
2	126	47	29	40.00	0.00
2	127	48	14	2.00	0.00
2	128	48	23	10.00	0.00
2	129	48	5	20.00	0.00
2	130	49	32	100.00	0.00
2	131	49	31	150.00	0.00
2	132	50	44	200.00	0.00
2	133	51	33	200.00	0.00
2	134	52	34	200.00	0.00
2	135	53	37	10.00	0.00
2	136	54	38	5.00	0.00
2	137	54	31	200.00	0.00
2	138	55	43	150.00	0.00
2	139	56	44	150.00	0.00
2	140	57	49	50.00	0.00
2	141	57	44	150.00	0.00
2	142	58	49	30.00	0.00
2	143	58	50	30.00	0.00
2	144	58	33	30.00	0.00
2	145	59	36	250.00	0.00
2	146	60	35	250.00	0.00
2	147	61	34	200.00	0.00
2	148	62	33	200.00	0.00
2	149	63	47	50.00	0.00
2	150	63	44	150.00	0.00
2	151	64	45	50.00	0.00
\.


--
-- TOC entry 3501 (class 0 OID 16445)
-- Dependencies: 231
-- Data for Name: restaurants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restaurants (r_id, restaurant) FROM stdin;
1	mc_fly
2	dublin
-9999	global
\.


--
-- TOC entry 3503 (class 0 OID 16449)
-- Dependencies: 233
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales (r_id, sale_id, product_id, sale_quantity, sale_date, sale_details) FROM stdin;
2	33	33	24.77	2025-07-19 00:48:52.36451	\N
2	34	34	31.33	2025-07-19 00:48:52.36451	\N
2	35	35	23.2	2025-07-19 00:48:52.36451	\N
2	36	36	27.33	2025-07-19 00:48:52.36451	\N
2	37	37	188.06	2025-07-19 00:48:52.36451	\N
2	38	38	2.46	2025-07-19 00:48:52.36451	\N
2	39	39	192.27	2025-07-19 00:48:52.36451	\N
2	40	40	25.76	2025-07-19 00:48:52.36451	\N
2	41	41	78.57	2025-07-19 00:48:52.36451	\N
2	42	42	26.14	2025-07-19 00:48:52.36451	\N
2	43	43	168.1	2025-07-19 00:48:52.36451	\N
2	44	44	118.84	2025-07-19 00:48:52.36451	\N
2	45	45	180.19	2025-07-19 00:48:52.36451	\N
2	46	46	12.49	2025-07-19 00:48:52.36451	\N
2	47	47	87.37	2025-07-19 00:48:52.36451	\N
2	48	48	154.96	2025-07-19 00:48:52.36451	\N
2	49	49	66.34	2025-07-19 00:48:52.36451	\N
2	50	50	5.7	2025-07-19 00:48:52.36451	\N
2	51	51	73.9	2025-07-19 00:48:52.36451	\N
2	52	52	99.49	2025-07-19 00:48:52.36451	\N
2	53	53	14.53	2025-07-19 00:48:52.36451	\N
2	54	54	86.55	2025-07-19 00:48:52.36451	\N
2	55	55	102.4	2025-07-19 00:48:52.36451	\N
2	56	56	139.88	2025-07-19 00:48:52.36451	\N
2	57	57	177.05	2025-07-19 00:48:52.36451	\N
2	58	58	109.02	2025-07-19 00:48:52.36451	\N
2	59	59	112.53	2025-07-19 00:48:52.36451	\N
2	60	60	23.49	2025-07-19 00:48:52.36451	\N
2	61	61	129.03	2025-07-19 00:48:52.36451	\N
2	62	62	75.5	2025-07-19 00:48:52.36451	\N
2	63	63	45.29	2025-07-19 00:48:52.36451	\N
2	64	64	113.05	2025-07-19 00:48:52.36451	\N
2	65	33	24.77	2025-07-19 00:55:32.749409	\N
2	66	34	31.33	2025-07-19 00:55:32.749409	\N
2	67	35	23.2	2025-07-19 00:55:32.749409	\N
2	68	36	27.33	2025-07-19 00:55:32.749409	\N
2	69	37	188.06	2025-07-19 00:55:32.749409	\N
2	70	38	2.46	2025-07-19 00:55:32.749409	\N
2	71	39	192.27	2025-07-19 00:55:32.749409	\N
2	72	40	25.76	2025-07-19 00:55:32.749409	\N
2	73	41	78.57	2025-07-19 00:55:32.749409	\N
2	74	42	26.14	2025-07-19 00:55:32.749409	\N
2	75	43	168.1	2025-07-19 00:55:32.749409	\N
2	76	44	118.84	2025-07-19 00:55:32.749409	\N
2	77	45	180.19	2025-07-19 00:55:32.749409	\N
2	78	46	12.49	2025-07-19 00:55:32.749409	\N
2	79	47	87.37	2025-07-19 00:55:32.749409	\N
2	80	48	154.96	2025-07-19 00:55:32.749409	\N
2	81	49	66.34	2025-07-19 00:55:32.749409	\N
2	82	50	5.7	2025-07-19 00:55:32.749409	\N
2	83	51	73.9	2025-07-19 00:55:32.749409	\N
2	84	52	99.49	2025-07-19 00:55:32.749409	\N
2	85	53	14.53	2025-07-19 00:55:32.749409	\N
2	86	54	86.55	2025-07-19 00:55:32.749409	\N
2	87	55	102.4	2025-07-19 00:55:32.749409	\N
2	88	56	139.88	2025-07-19 00:55:32.749409	\N
2	89	57	177.05	2025-07-19 00:55:32.749409	\N
2	90	58	109.02	2025-07-19 00:55:32.749409	\N
2	91	59	112.53	2025-07-19 00:55:32.749409	\N
2	92	60	23.49	2025-07-19 00:55:32.749409	\N
2	93	61	129.03	2025-07-19 00:55:32.749409	\N
2	94	62	75.5	2025-07-19 00:55:32.749409	\N
2	95	63	45.29	2025-07-19 00:55:32.749409	\N
2	96	64	113.05	2025-07-19 00:55:32.749409	\N
1	97	1	9	2025-08-21 00:39:41.346132	\N
1	98	29	8	2025-08-21 00:39:41.346132	\N
1	99	26	5	2025-08-21 00:39:41.346132	\N
1	100	20	1	2025-08-21 00:39:41.346132	\N
1	101	24	7	2025-08-21 00:39:41.346132	\N
1	102	13	6	2025-08-21 00:39:41.346132	\N
1	103	24	6	2025-08-21 00:39:41.346132	\N
1	104	26	1	2025-08-21 00:39:41.346132	\N
1	105	9	8	2025-08-21 00:39:41.346132	\N
1	106	26	7	2025-08-21 00:39:41.346132	\N
1	107	2	8	2025-08-21 00:39:41.346132	\N
1	108	8	2	2025-08-21 00:39:41.346132	\N
1	109	18	2	2025-08-21 00:39:41.346132	\N
1	110	26	4	2025-08-21 00:39:41.346132	\N
1	111	19	4	2025-08-21 00:39:41.346132	\N
1	112	3	7	2025-08-21 00:39:41.346132	\N
1	113	5	5	2025-08-21 00:39:41.346132	\N
1	114	18	10	2025-08-21 00:39:41.346132	\N
1	115	32	3	2025-08-21 00:39:41.346132	\N
1	116	16	6	2025-08-21 00:39:41.346132	\N
1	117	14	1	2025-08-21 00:39:41.346132	\N
1	118	30	3	2025-08-21 00:39:41.346132	\N
1	119	10	9	2025-08-21 00:39:41.346132	\N
1	120	2	10	2025-08-21 00:39:41.346132	\N
1	121	18	9	2025-08-21 00:39:41.346132	\N
1	122	9	8	2025-08-21 00:39:41.346132	\N
1	123	10	1	2025-08-21 00:39:41.346132	\N
1	124	27	6	2025-08-21 00:39:41.346132	\N
1	125	12	8	2025-08-21 00:39:41.346132	\N
1	126	22	8	2025-08-21 00:39:41.346132	\N
1	127	30	5	2025-08-21 00:39:41.346132	\N
1	128	9	10	2025-08-21 00:39:41.346132	\N
1	129	23	2	2025-08-21 00:39:41.346132	\N
1	130	14	9	2025-08-21 00:39:41.346132	\N
1	131	14	2	2025-08-21 00:39:41.346132	\N
1	132	2	6	2025-08-21 00:39:41.346132	\N
1	133	27	6	2025-08-21 00:39:41.346132	\N
1	134	21	4	2025-08-21 00:39:41.346132	\N
1	135	8	7	2025-08-21 00:39:41.346132	\N
1	136	30	1	2025-08-21 00:39:41.346132	\N
1	137	28	1	2025-08-21 00:39:41.346132	\N
1	138	24	2	2025-08-21 00:39:41.346132	\N
1	139	13	5	2025-08-21 00:39:41.346132	\N
1	140	16	6	2025-08-21 00:39:41.346132	\N
1	141	30	4	2025-08-21 00:39:41.346132	\N
1	142	18	5	2025-08-21 00:39:41.346132	\N
1	143	18	9	2025-08-21 00:39:41.346132	\N
1	144	21	3	2025-08-21 00:39:41.346132	\N
1	145	8	9	2025-08-21 00:39:41.346132	\N
1	146	31	8	2025-08-21 00:39:41.346132	\N
2	147	57	1	2025-08-21 00:39:41.346132	\N
2	148	41	5	2025-08-21 00:39:41.346132	\N
2	149	34	8	2025-08-21 00:39:41.346132	\N
2	150	56	1	2025-08-21 00:39:41.346132	\N
2	151	46	2	2025-08-21 00:39:41.346132	\N
2	152	63	8	2025-08-21 00:39:41.346132	\N
2	153	59	7	2025-08-21 00:39:41.346132	\N
2	154	60	7	2025-08-21 00:39:41.346132	\N
2	155	59	2	2025-08-21 00:39:41.346132	\N
2	156	55	4	2025-08-21 00:39:41.346132	\N
2	157	59	10	2025-08-21 00:39:41.346132	\N
2	158	36	3	2025-08-21 00:39:41.346132	\N
2	159	51	9	2025-08-21 00:39:41.346132	\N
2	160	54	2	2025-08-21 00:39:41.346132	\N
2	161	47	4	2025-08-21 00:39:41.346132	\N
2	162	63	3	2025-08-21 00:39:41.346132	\N
2	163	46	1	2025-08-21 00:39:41.346132	\N
2	164	43	5	2025-08-21 00:39:41.346132	\N
2	165	48	9	2025-08-21 00:39:41.346132	\N
2	166	48	7	2025-08-21 00:39:41.346132	\N
2	167	52	9	2025-08-21 00:39:41.346132	\N
2	168	34	9	2025-08-21 00:39:41.346132	\N
2	169	59	2	2025-08-21 00:39:41.346132	\N
2	170	48	3	2025-08-21 00:39:41.346132	\N
2	171	38	2	2025-08-21 00:39:41.346132	\N
2	172	48	2	2025-08-21 00:39:41.346132	\N
2	173	50	1	2025-08-21 00:39:41.346132	\N
2	174	58	4	2025-08-21 00:39:41.346132	\N
2	175	33	10	2025-08-21 00:39:41.346132	\N
2	176	54	2	2025-08-21 00:39:41.346132	\N
2	177	43	8	2025-08-21 00:39:41.346132	\N
2	178	42	3	2025-08-21 00:39:41.346132	\N
2	179	51	6	2025-08-21 00:39:41.346132	\N
2	180	47	10	2025-08-21 00:39:41.346132	\N
2	181	58	8	2025-08-21 00:39:41.346132	\N
2	182	53	4	2025-08-21 00:39:41.346132	\N
2	183	63	2	2025-08-21 00:39:41.346132	\N
2	184	40	9	2025-08-21 00:39:41.346132	\N
2	185	53	6	2025-08-21 00:39:41.346132	\N
2	186	50	9	2025-08-21 00:39:41.346132	\N
2	187	64	9	2025-08-21 00:39:41.346132	\N
2	188	41	1	2025-08-21 00:39:41.346132	\N
2	189	46	5	2025-08-21 00:39:41.346132	\N
2	190	33	5	2025-08-21 00:39:41.346132	\N
2	191	63	4	2025-08-21 00:39:41.346132	\N
2	192	62	4	2025-08-21 00:39:41.346132	\N
2	193	47	2	2025-08-21 00:39:41.346132	\N
2	194	64	10	2025-08-21 00:39:41.346132	\N
2	195	34	9	2025-08-21 00:39:41.346132	\N
2	196	61	5	2025-08-21 00:39:41.346132	\N
\.


--
-- TOC entry 3505 (class 0 OID 16456)
-- Dependencies: 235
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock (r_id, rm_id, stock_amount) FROM stdin;
1	7	140000.0
1	9	140000.0
1	16	140000.0
1	17	140000.0
1	24	140000.0
1	27	140000.0
1	28	140000.0
1	29	140000.0
1	30	140000.0
1	38	140000.0
1	40	140000.0
1	1	136340.0
1	2	139820.0
1	3	137720.0
1	4	139880.0
1	5	139520.0
1	6	135470.0
1	8	139560.0
1	10	139750.0
1	11	139975.0
1	12	139500.0
1	13	139270.0
1	14	100358.0
1	15	139280.0
1	18	139460.0
1	19	139640.0
1	20	138680.0
1	21	139700.0
1	22	138560.0
1	23	139175.0
1	25	139090.0
1	26	138800.0
1	31	132300.0
1	32	133000.0
1	33	136600.0
1	34	138400.0
1	35	136800.0
1	36	139750.0
1	37	139930.0
1	39	139960.0
1	41	139700.0
1	42	137750.0
1	43	139830.0
1	44	139830.0
1	46	139150.0
1	47	139600.0
1	48	139850.0
2	56	139640.0
2	57	139880.0
2	58	139130.0
2	59	139825.0
2	60	138900.0
2	61	138200.0
2	63	139700.0
2	64	139940.0
2	67	138960.0
2	68	139880.0
1	45	140000.0
1	49	140000.0
1	50	140000.0
1	51	140000.0
1	52	140000.0
1	53	140000.0
1	54	140000.0
1	55	140000.0
2	62	140000.0
2	65	140000.0
2	66	140000.0
2	70	140000.0
2	71	140000.0
2	73	140000.0
2	74	140000.0
2	76	140000.0
2	78	140000.0
2	80	140000.0
2	81	140000.0
2	84	140000.0
2	86	140000.0
2	93	140000.0
2	94	140000.0
2	95	140000.0
2	96	140000.0
2	100	140000.0
2	102	140000.0
2	105	140000.0
2	106	140000.0
2	107	140000.0
2	108	140000.0
2	109	140000.0
2	69	139910.0
2	72	139910.0
2	75	139730.0
2	77	139430.0
2	79	138460.0
2	82	139200.0
2	83	139360.0
2	85	138570.0
2	87	135840.0
2	88	137200.0
2	89	138250.0
2	90	134750.0
2	91	139900.0
2	92	139980.0
2	97	139400.0
2	98	135150.0
2	99	139050.0
2	101	139150.0
2	103	139590.0
2	104	139640.0
2	110	139917.0
\.


--
-- TOC entry 3506 (class 0 OID 16462)
-- Dependencies: 236
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_movements (r_id, movement_id, rm_id, movement_amount, movement_type, movement_date, movement_details) FROM stdin;
2	368	61	2972.4	stock_out	2025-07-19 00:48:52.36451	\N
2	369	57	1153.6000000000001	stock_out	2025-07-19 00:48:52.36451	\N
2	370	77	5023.6	stock_out	2025-07-19 00:48:52.36451	\N
2	371	58	1724.1	stock_out	2025-07-19 00:48:52.36451	\N
2	372	59	285.45	stock_out	2025-07-19 00:48:52.36451	\N
2	373	60	4634.5	stock_out	2025-07-19 00:48:52.36451	\N
2	374	62	3480.0	stock_out	2025-07-19 00:48:52.36451	\N
2	375	63	2733.0	stock_out	2025-07-19 00:48:52.36451	\N
2	376	75	3177.0	stock_out	2025-07-19 00:48:52.36451	\N
2	377	110	895.49	stock_out	2025-07-19 00:48:52.36451	\N
2	378	64	546.5999999999999	stock_out	2025-07-19 00:48:52.36451	\N
2	379	65	11283.6	stock_out	2025-07-19 00:48:52.36451	\N
2	380	67	32254.0	stock_out	2025-07-19 00:48:52.36451	\N
2	381	68	9550.6	stock_out	2025-07-19 00:48:52.36451	\N
2	382	84	11536.2	stock_out	2025-07-19 00:48:52.36451	\N
2	383	72	6552.3	stock_out	2025-07-19 00:48:52.36451	\N
2	384	56	8559.6	stock_out	2025-07-19 00:48:52.36451	\N
2	385	85	29064.2	stock_out	2025-07-19 00:48:52.36451	\N
1	276	1	4667	stock_in	2025-07-18 23:48:46.10508	\N
1	277	2	3342	stock_in	2025-07-18 23:48:46.10508	\N
1	278	3	4231	stock_in	2025-07-18 23:48:46.10508	\N
1	279	4	2242	stock_in	2025-07-18 23:48:46.10508	\N
1	280	5	3540	stock_in	2025-07-18 23:48:46.10508	\N
1	281	6	3661	stock_in	2025-07-18 23:48:46.10508	\N
1	282	7	4800	stock_in	2025-07-18 23:48:46.10508	\N
1	283	8	904	stock_in	2025-07-18 23:48:46.10508	\N
1	284	9	2740	stock_in	2025-07-18 23:48:46.10508	\N
1	285	10	1640	stock_in	2025-07-18 23:48:46.10508	\N
1	286	11	4925	stock_in	2025-07-18 23:48:46.10508	\N
1	287	12	4473	stock_in	2025-07-18 23:48:46.10508	\N
1	288	13	4222	stock_in	2025-07-18 23:48:46.10508	\N
1	289	15	509	stock_in	2025-07-18 23:48:46.10508	\N
1	290	16	3566	stock_in	2025-07-18 23:48:46.10508	\N
1	291	17	4008	stock_in	2025-07-18 23:48:46.10508	\N
1	292	18	87	stock_in	2025-07-18 23:48:46.10508	\N
1	293	19	4122	stock_in	2025-07-18 23:48:46.10508	\N
1	294	20	2534	stock_in	2025-07-18 23:48:46.10508	\N
1	295	21	1361	stock_in	2025-07-18 23:48:46.10508	\N
1	296	22	2750	stock_in	2025-07-18 23:48:46.10508	\N
1	297	23	4765	stock_in	2025-07-18 23:48:46.10508	\N
1	298	24	4290	stock_in	2025-07-18 23:48:46.10508	\N
1	299	25	1768	stock_in	2025-07-18 23:48:46.10508	\N
1	300	26	2817	stock_in	2025-07-18 23:48:46.10508	\N
1	301	27	1534	stock_in	2025-07-18 23:48:46.10508	\N
1	302	28	2498	stock_in	2025-07-18 23:48:46.10508	\N
1	303	29	4994	stock_in	2025-07-18 23:48:46.10508	\N
1	304	30	3152	stock_in	2025-07-18 23:48:46.10508	\N
1	305	31	4316	stock_in	2025-07-18 23:48:46.10508	\N
1	306	32	4246	stock_in	2025-07-18 23:48:46.10508	\N
1	307	33	2960	stock_in	2025-07-18 23:48:46.10508	\N
1	308	34	3468	stock_in	2025-07-18 23:48:46.10508	\N
1	309	35	3895	stock_in	2025-07-18 23:48:46.10508	\N
1	310	36	4128	stock_in	2025-07-18 23:48:46.10508	\N
1	311	37	3661	stock_in	2025-07-18 23:48:46.10508	\N
1	312	38	658	stock_in	2025-07-18 23:48:46.10508	\N
1	313	39	2188	stock_in	2025-07-18 23:48:46.10508	\N
1	314	40	291	stock_in	2025-07-18 23:48:46.10508	\N
1	315	41	843	stock_in	2025-07-18 23:48:46.10508	\N
1	316	42	3347	stock_in	2025-07-18 23:48:46.10508	\N
1	317	43	2979	stock_in	2025-07-18 23:48:46.10508	\N
1	318	44	4868	stock_in	2025-07-18 23:48:46.10508	\N
1	319	45	2209	stock_in	2025-07-18 23:48:46.10508	\N
1	320	46	3629	stock_in	2025-07-18 23:48:46.10508	\N
1	321	47	738	stock_in	2025-07-18 23:48:46.10508	\N
1	322	48	893	stock_in	2025-07-18 23:48:46.10508	\N
1	323	49	2166	stock_in	2025-07-18 23:48:46.10508	\N
1	324	50	4958	stock_in	2025-07-18 23:48:46.10508	\N
1	325	51	305	stock_in	2025-07-18 23:48:46.10508	\N
1	326	52	4151	stock_in	2025-07-18 23:48:46.10508	\N
1	327	53	1652	stock_in	2025-07-18 23:48:46.10508	\N
1	328	54	3707	stock_in	2025-07-18 23:48:46.10508	\N
1	329	55	2374	stock_in	2025-07-18 23:48:46.10508	\N
1	330	14	4639	stock_in	2025-07-18 23:48:46.10508	\N
2	386	69	784.2	stock_out	2025-07-19 00:48:52.36451	\N
2	387	79	22590.4	stock_out	2025-07-19 00:48:52.36451	\N
2	388	78	14260.800000000001	stock_out	2025-07-19 00:48:52.36451	\N
2	389	81	18019.0	stock_out	2025-07-19 00:48:52.36451	\N
2	390	82	1249.0	stock_out	2025-07-19 00:48:52.36451	\N
2	391	83	3494.8	stock_out	2025-07-19 00:48:52.36451	\N
2	392	86	6634.0	stock_out	2025-07-19 00:48:52.36451	\N
2	393	98	55473.0	stock_out	2025-07-19 00:48:52.36451	\N
2	394	87	33150.600000000006	stock_out	2025-07-19 00:48:52.36451	\N
2	395	88	45704.0	stock_out	2025-07-19 00:48:52.36451	\N
2	396	91	145.29999999999998	stock_out	2025-07-19 00:48:52.36451	\N
2	397	92	432.75	stock_out	2025-07-19 00:48:52.36451	\N
2	398	97	15360.0	stock_out	2025-07-19 00:48:52.36451	\N
2	399	103	12123.1	stock_out	2025-07-19 00:48:52.36451	\N
2	400	104	3270.6	stock_out	2025-07-19 00:48:52.36451	\N
2	401	90	28132.5	stock_out	2025-07-19 00:48:52.36451	\N
2	402	89	5872.5	stock_out	2025-07-19 00:48:52.36451	\N
2	403	101	2264.5	stock_out	2025-07-19 00:48:52.36451	\N
2	404	99	5652.5	stock_out	2025-07-19 00:48:52.36451	\N
2	405	61	2972.4	stock_out	2025-07-19 00:55:32.749409	\N
2	406	57	1153.6000000000001	stock_out	2025-07-19 00:55:32.749409	\N
2	407	77	5023.6	stock_out	2025-07-19 00:55:32.749409	\N
2	408	58	1724.1	stock_out	2025-07-19 00:55:32.749409	\N
2	409	59	285.45	stock_out	2025-07-19 00:55:32.749409	\N
2	410	60	4634.5	stock_out	2025-07-19 00:55:32.749409	\N
2	411	62	3480.0	stock_out	2025-07-19 00:55:32.749409	\N
2	412	63	2733.0	stock_out	2025-07-19 00:55:32.749409	\N
2	413	75	3177.0	stock_out	2025-07-19 00:55:32.749409	\N
2	414	110	895.49	stock_out	2025-07-19 00:55:32.749409	\N
2	415	64	546.5999999999999	stock_out	2025-07-19 00:55:32.749409	\N
2	416	65	11283.6	stock_out	2025-07-19 00:55:32.749409	\N
2	417	67	32254.0	stock_out	2025-07-19 00:55:32.749409	\N
2	418	68	9550.6	stock_out	2025-07-19 00:55:32.749409	\N
2	419	84	11536.2	stock_out	2025-07-19 00:55:32.749409	\N
2	420	72	6552.3	stock_out	2025-07-19 00:55:32.749409	\N
2	421	56	8559.6	stock_out	2025-07-19 00:55:32.749409	\N
2	422	85	29064.2	stock_out	2025-07-19 00:55:32.749409	\N
2	423	69	784.2	stock_out	2025-07-19 00:55:32.749409	\N
2	424	79	22590.4	stock_out	2025-07-19 00:55:32.749409	\N
2	425	78	14260.800000000001	stock_out	2025-07-19 00:55:32.749409	\N
2	426	81	18019.0	stock_out	2025-07-19 00:55:32.749409	\N
2	427	82	1249.0	stock_out	2025-07-19 00:55:32.749409	\N
2	428	83	3494.8	stock_out	2025-07-19 00:55:32.749409	\N
2	429	86	6634.0	stock_out	2025-07-19 00:55:32.749409	\N
2	430	98	55473.0	stock_out	2025-07-19 00:55:32.749409	\N
2	431	87	33150.600000000006	stock_out	2025-07-19 00:55:32.749409	\N
2	432	88	45704.0	stock_out	2025-07-19 00:55:32.749409	\N
2	433	91	145.29999999999998	stock_out	2025-07-19 00:55:32.749409	\N
2	434	92	432.75	stock_out	2025-07-19 00:55:32.749409	\N
2	435	97	15360.0	stock_out	2025-07-19 00:55:32.749409	\N
2	436	103	12123.1	stock_out	2025-07-19 00:55:32.749409	\N
2	437	104	3270.6	stock_out	2025-07-19 00:55:32.749409	\N
2	438	90	28132.5	stock_out	2025-07-19 00:55:32.749409	\N
2	439	89	5872.5	stock_out	2025-07-19 00:55:32.749409	\N
2	440	101	2264.5	stock_out	2025-07-19 00:55:32.749409	\N
2	441	99	5652.5	stock_out	2025-07-19 00:55:32.749409	\N
1	442	1	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	443	17	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	444	44	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	445	18	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	446	48	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	447	43	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	448	28	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	449	20	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	450	51	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	451	13	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	452	9	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	453	26	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	454	34	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	455	29	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	456	24	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	457	12	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	458	42	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	459	49	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	460	40	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	461	45	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	462	46	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	463	10	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	464	53	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	465	22	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	466	5	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	467	50	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	468	16	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	469	37	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	470	31	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	471	4	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	472	27	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	473	11	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	474	38	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	475	41	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	476	52	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	477	36	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	478	21	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	479	47	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	480	15	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	481	8	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	482	23	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	483	39	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	484	3	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	485	19	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	486	33	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	487	54	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	488	2	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	489	30	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	490	55	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	491	6	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	492	35	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	493	25	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	494	32	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	495	7	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	496	14	100	stock_in	2025-08-19 14:08:16.699898	\N
2	497	56	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	498	71	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	499	98	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	500	72	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	501	102	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	502	97	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	503	82	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	504	74	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	505	105	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	506	68	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	507	64	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	508	80	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	509	88	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	510	83	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	511	78	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	512	67	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	513	96	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	514	103	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	515	94	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	516	99	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	517	100	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	518	65	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	519	107	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	520	76	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	521	60	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	522	104	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	523	70	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	524	91	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	525	85	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	526	59	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	527	81	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	528	66	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	529	92	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	530	95	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	531	106	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	532	90	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	533	75	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	534	101	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	535	69	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	536	63	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	537	77	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	538	93	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	539	58	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	540	73	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	541	87	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	542	108	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	543	57	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	544	84	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	545	109	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	546	61	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	547	89	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	548	79	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	549	86	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	550	62	10000	stock_in	2025-08-19 14:08:16.699898	\N
2	551	110	10000	stock_in	2025-08-19 14:08:16.699898	\N
1	552	34	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	553	25	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	554	5	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	555	54	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	556	23	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	557	53	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	558	55	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	559	24	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	560	12	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	561	43	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	562	6	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	563	44	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	564	35	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	565	42	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	566	4	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	567	14	100	stock_in	2025-08-19 14:46:35.901193	\N
1	568	37	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	569	9	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	570	19	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	571	20	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	572	40	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	573	48	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	574	17	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	575	26	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	576	28	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	577	30	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	578	13	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	579	27	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	580	38	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	581	46	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	582	29	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	583	10	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	584	7	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	585	11	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	586	45	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	587	41	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	588	8	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	589	18	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	590	16	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	591	39	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	592	51	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	593	50	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	594	33	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	595	3	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	596	32	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	597	22	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	598	47	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	599	36	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	600	1	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	601	15	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	602	52	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	603	21	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	604	2	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	605	49	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	606	31	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	607	88	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	608	79	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	609	60	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	610	108	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	611	77	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	612	107	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	613	109	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	614	78	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	615	67	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	616	97	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	617	61	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	618	98	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	619	89	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	620	96	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	621	59	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	622	110	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	623	91	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	624	64	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	625	73	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	626	74	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	627	94	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	628	102	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	629	71	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	630	80	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	631	82	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	632	84	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	633	68	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	634	81	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	635	92	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	636	100	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	637	83	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	638	65	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	639	62	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	640	66	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	641	99	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	642	95	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	643	63	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	644	72	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	645	70	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	646	93	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	647	105	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	648	104	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	649	87	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	650	58	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	651	86	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	652	76	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	653	101	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	654	90	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	655	56	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	656	69	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	657	106	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	658	75	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	659	57	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	660	103	10000	stock_in	2025-08-19 14:46:35.901193	\N
2	661	85	10000	stock_in	2025-08-19 14:46:35.901193	\N
1	662	34	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	663	25	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	664	5	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	665	54	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	666	23	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	667	53	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	668	55	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	669	24	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	670	12	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	671	43	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	672	6	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	673	44	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	674	35	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	675	42	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	676	4	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	677	14	100	stock_in	2025-08-19 21:20:39.982725	\N
1	678	37	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	679	9	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	680	19	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	681	20	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	682	40	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	683	48	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	684	17	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	685	26	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	686	28	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	687	30	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	688	13	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	689	27	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	690	38	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	691	46	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	692	29	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	693	10	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	694	7	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	695	11	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	696	45	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	697	41	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	698	8	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	699	18	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	700	16	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	701	39	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	702	51	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	703	50	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	704	33	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	705	3	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	706	32	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	707	22	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	708	47	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	709	36	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	710	1	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	711	15	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	712	52	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	713	21	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	714	2	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	715	49	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	716	31	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	717	88	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	718	79	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	719	60	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	720	108	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	721	77	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	722	107	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	723	109	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	724	78	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	725	67	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	726	97	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	727	61	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	728	98	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	729	89	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	730	96	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	731	59	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	732	110	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	733	91	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	734	64	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	735	73	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	736	74	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	737	94	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	738	102	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	739	71	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	740	80	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	741	82	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	742	84	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	743	68	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	744	81	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	745	92	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	746	100	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	747	83	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	748	65	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	749	62	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	750	66	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	751	99	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	752	95	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	753	63	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	754	72	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	755	70	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	756	93	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	757	105	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	758	104	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	759	87	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	760	58	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	761	86	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	762	76	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	763	101	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	764	90	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	765	56	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	766	69	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	767	106	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	768	75	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	769	57	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	770	103	10000	stock_in	2025-08-19 21:20:39.982725	\N
2	771	85	10000	stock_in	2025-08-19 21:20:39.982725	\N
1	772	34	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	773	25	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	774	5	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	775	54	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	776	23	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	777	53	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	778	55	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	779	24	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	780	12	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	781	43	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	782	6	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	783	44	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	784	35	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	785	42	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	786	4	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	787	14	100	stock_in	2025-08-19 21:44:59.131492	\N
1	788	37	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	789	9	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	790	19	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	791	20	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	792	40	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	793	48	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	794	17	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	795	26	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	796	28	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	797	30	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	798	13	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	799	27	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	800	38	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	801	46	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	802	29	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	803	10	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	804	7	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	805	11	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	806	45	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	807	41	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	808	8	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	809	18	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	810	16	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	811	39	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	812	51	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	813	50	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	814	33	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	815	3	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	816	32	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	817	22	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	818	47	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	819	36	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	820	1	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	821	15	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	822	52	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	823	21	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	824	2	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	825	49	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	826	31	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	827	88	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	828	79	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	829	60	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	830	108	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	831	77	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	832	107	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	833	109	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	834	78	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	835	67	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	836	97	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	837	61	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	838	98	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	839	89	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	840	96	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	841	59	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	842	110	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	843	91	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	844	64	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	845	73	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	846	74	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	847	94	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	848	102	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	849	71	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	850	80	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	851	82	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	852	84	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	853	68	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	854	81	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	855	92	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	856	100	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	857	83	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	858	65	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	859	62	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	860	66	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	861	99	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	862	95	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	863	63	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	864	72	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	865	70	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	866	93	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	867	105	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	868	104	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	869	87	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	870	58	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	871	86	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	872	76	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	873	101	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	874	90	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	875	56	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	876	69	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	877	106	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	878	75	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	879	57	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	880	103	10000	stock_in	2025-08-19 21:44:59.131492	\N
2	881	85	10000	stock_in	2025-08-19 21:44:59.131492	\N
1	882	34	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	883	25	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	884	5	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	885	54	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	886	23	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	887	53	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	888	55	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	889	24	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	890	12	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	891	43	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	892	6	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	893	44	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	894	35	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	895	42	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	896	4	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	897	14	100	stock_in	2025-08-19 22:29:36.95655	\N
1	898	37	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	899	9	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	900	19	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	901	20	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	902	40	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	903	48	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	904	17	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	905	26	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	906	28	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	907	30	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	908	13	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	909	27	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	910	38	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	911	46	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	912	29	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	913	10	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	914	7	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	915	11	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	916	45	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	917	41	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	918	8	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	919	18	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	920	16	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	921	39	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	922	51	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	923	50	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	924	33	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	925	3	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	926	32	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	927	22	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	928	47	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	929	36	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	930	1	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	931	15	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	932	52	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	933	21	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	934	2	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	935	49	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	936	31	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	937	88	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	938	79	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	939	60	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	940	108	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	941	77	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	942	107	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	943	109	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	944	78	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	945	67	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	946	97	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	947	61	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	948	98	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	949	89	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	950	96	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	951	59	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	952	110	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	953	91	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	954	64	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	955	73	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	956	74	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	957	94	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	958	102	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	959	71	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	960	80	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	961	82	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	962	84	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	963	68	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	964	81	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	965	92	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	966	100	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	967	83	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	968	65	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	969	62	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	970	66	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	971	99	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	972	95	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	973	63	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	974	72	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	975	70	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	976	93	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	977	105	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	978	104	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	979	87	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	980	58	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	981	86	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	982	76	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	983	101	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	984	90	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	985	56	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	986	69	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	987	106	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	988	75	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	989	57	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	990	103	10000	stock_in	2025-08-19 22:29:36.95655	\N
2	991	85	10000	stock_in	2025-08-19 22:29:36.95655	\N
1	992	46	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	993	55	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	994	45	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	995	12	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	996	1	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	997	39	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	998	32	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	999	33	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1000	5	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1001	28	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1002	26	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1003	42	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1004	11	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1005	16	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1006	19	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1007	34	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1008	23	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1009	8	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1010	30	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1011	43	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1012	27	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1013	25	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1014	50	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1015	53	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1016	6	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1017	24	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1018	44	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1019	10	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1020	17	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1021	54	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1022	20	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1023	2	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1024	49	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1025	3	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1026	52	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1027	18	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1028	41	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1029	47	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1030	51	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1031	13	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1032	31	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1033	4	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1034	15	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1035	37	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1036	38	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1037	14	100	stock_in	2025-08-19 22:57:08.493195	\N
1	1038	7	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1039	35	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1040	9	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1041	21	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1042	36	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1043	48	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1044	22	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1045	40	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1046	29	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1047	100	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1048	109	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1049	99	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1050	67	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1051	56	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1052	93	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1053	86	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1054	87	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1055	60	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1056	82	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1057	80	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1058	96	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1059	66	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1060	70	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1061	73	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1062	88	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1063	77	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1064	63	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1065	84	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1066	97	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1067	81	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1068	79	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1069	104	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1070	107	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1071	61	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1072	78	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1073	98	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1074	65	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1075	71	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1076	108	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1077	74	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1078	57	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1079	103	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1080	58	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1081	106	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1082	72	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1083	95	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1084	101	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1085	105	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1086	68	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1087	85	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1088	59	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1089	69	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1090	91	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1091	92	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1092	110	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1093	62	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1094	89	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1095	64	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1096	75	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1097	90	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1098	102	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1099	76	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1100	94	10000	stock_in	2025-08-19 22:57:08.493195	\N
2	1101	83	10000	stock_in	2025-08-19 22:57:08.493195	\N
1	1102	30	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1103	10	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1104	45	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1105	47	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1106	1	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1107	46	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1108	27	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1109	23	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1110	15	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1111	34	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1112	33	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1113	31	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1114	42	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1115	51	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1116	14	100	stock_in	2025-08-19 23:34:38.705798	\N
1	1117	54	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1118	17	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1119	16	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1120	50	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1121	44	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1122	39	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1123	29	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1124	3	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1125	5	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1126	32	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1127	40	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1128	38	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1129	6	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1130	2	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1131	36	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1132	18	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1133	35	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1134	11	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1135	19	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1136	48	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1137	49	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1138	55	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1139	9	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1140	12	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1141	43	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1142	52	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1143	20	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1144	41	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1145	53	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1146	21	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1147	7	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1148	24	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1149	28	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1150	8	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1151	22	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1152	4	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1153	25	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1154	26	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1155	13	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1156	37	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1157	84	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1158	65	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1159	99	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1160	101	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1161	56	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1162	100	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1163	81	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1164	77	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1165	69	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1166	88	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1167	87	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1168	85	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1169	96	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1170	105	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1171	110	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1172	108	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1173	71	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1174	70	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1175	104	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1176	98	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1177	93	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1178	83	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1179	58	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1180	60	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1181	86	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1182	94	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1183	92	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1184	61	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1185	57	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1186	90	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1187	72	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1188	89	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1189	66	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1190	73	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1191	102	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1192	103	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1193	109	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1194	64	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1195	67	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1196	97	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1197	106	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1198	74	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1199	95	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1200	107	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1201	75	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1202	62	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1203	78	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1204	82	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1205	63	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1206	76	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1207	59	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1208	79	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1209	80	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1210	68	10000	stock_in	2025-08-19 23:34:38.705798	\N
2	1211	91	10000	stock_in	2025-08-19 23:34:38.705798	\N
1	1212	7	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1213	23	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1214	1	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1215	9	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1216	31	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1217	5	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1218	4	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1219	50	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1220	18	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1221	13	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1222	17	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1223	39	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1224	12	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1225	42	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1226	27	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1227	6	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1228	29	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1229	20	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1230	21	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1231	37	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1232	45	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1233	52	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1234	34	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1235	40	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1236	8	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1237	33	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1238	15	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1239	3	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1240	43	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1241	54	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1242	38	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1243	24	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1244	32	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1245	46	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1246	14	100	stock_in	2025-08-19 23:34:47.188469	\N
1	1247	11	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1248	51	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1249	25	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1250	10	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1251	41	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1252	2	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1253	30	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1254	16	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1255	28	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1256	19	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1257	48	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1258	44	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1259	53	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1260	47	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1261	49	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1262	55	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1263	36	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1264	26	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1265	22	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1266	35	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1267	62	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1268	77	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1269	56	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1270	64	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1271	85	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1272	60	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1273	59	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1274	104	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1275	72	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1276	68	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1277	71	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1278	93	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1279	67	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1280	96	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1281	81	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1282	61	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1283	83	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1284	74	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1285	75	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1286	91	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1287	99	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1288	106	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1289	88	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1290	94	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1291	63	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1292	87	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1293	69	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1294	58	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1295	97	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1296	108	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1297	92	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1298	78	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1299	86	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1300	100	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1301	110	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1302	66	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1303	105	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1304	79	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1305	65	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1306	95	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1307	57	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1308	84	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1309	70	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1310	82	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1311	73	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1312	102	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1313	98	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1314	107	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1315	101	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1316	103	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1317	109	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1318	90	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1319	80	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1320	76	10000	stock_in	2025-08-19 23:34:47.188469	\N
2	1321	89	10000	stock_in	2025-08-19 23:34:47.188469	\N
1	1322	13	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1323	38	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1324	43	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1325	51	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1326	17	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1327	53	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1328	41	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1329	44	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1330	21	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1331	33	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1332	36	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1333	49	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1334	34	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1335	9	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1336	15	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1337	4	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1338	45	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1339	39	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1340	16	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1341	28	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1342	37	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1343	11	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1344	48	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1345	1	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1346	30	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1347	2	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1348	35	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1349	12	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1350	3	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1351	22	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1352	52	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1353	19	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1354	32	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1355	27	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1356	18	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1357	29	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1358	40	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1359	10	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1360	54	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1361	14	100	stock_in	2025-08-19 23:49:13.07115	\N
1	1362	20	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1363	5	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1364	8	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1365	23	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1366	6	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1367	47	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1368	26	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1369	7	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1370	55	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1371	46	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1372	50	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1373	42	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1374	31	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1375	24	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1376	25	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1377	68	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1378	92	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1379	97	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1380	105	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1381	71	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1382	107	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1383	95	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1384	98	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1385	75	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1386	87	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1387	90	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1388	103	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1389	88	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1390	64	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1391	69	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1392	59	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1393	99	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1394	93	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1395	70	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1396	82	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1397	91	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1398	66	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1399	102	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1400	56	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1401	84	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1402	57	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1403	89	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1404	67	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1405	58	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1406	76	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1407	106	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1408	73	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1409	86	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1410	81	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1411	72	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1412	83	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1413	94	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1414	65	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1415	108	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1416	110	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1417	74	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1418	60	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1419	63	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1420	77	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1421	61	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1422	101	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1423	80	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1424	62	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1425	109	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1426	100	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1427	104	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1428	96	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1429	85	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1430	78	10000	stock_in	2025-08-19 23:49:13.07115	\N
2	1431	79	10000	stock_in	2025-08-19 23:49:13.07115	\N
1	1432	13	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1433	38	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1434	43	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1435	51	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1436	17	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1437	53	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1438	41	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1439	44	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1440	21	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1441	33	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1442	36	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1443	49	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1444	34	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1445	9	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1446	15	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1447	4	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1448	45	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1449	39	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1450	16	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1451	28	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1452	37	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1453	11	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1454	48	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1455	1	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1456	30	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1457	2	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1458	35	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1459	12	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1460	3	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1461	22	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1462	52	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1463	19	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1464	32	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1465	27	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1466	18	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1467	29	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1468	40	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1469	10	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1470	54	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1471	14	100	stock_in	2025-08-21 00:03:38.1667	\N
1	1472	20	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1473	5	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1474	8	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1475	23	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1476	6	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1477	47	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1478	26	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1479	7	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1480	55	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1481	46	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1482	50	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1483	42	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1484	31	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1485	24	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1486	25	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1487	68	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1488	92	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1489	97	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1490	105	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1491	71	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1492	107	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1493	95	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1494	98	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1495	75	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1496	87	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1497	90	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1498	103	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1499	88	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1500	64	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1501	69	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1502	59	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1503	99	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1504	93	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1505	70	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1506	82	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1507	91	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1508	66	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1509	102	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1510	56	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1511	84	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1512	57	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1513	89	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1514	67	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1515	58	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1516	76	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1517	106	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1518	73	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1519	86	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1520	81	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1521	72	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1522	83	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1523	94	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1524	65	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1525	108	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1526	110	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1527	74	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1528	60	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1529	63	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1530	77	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1531	61	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1532	101	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1533	80	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1534	62	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1535	109	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1536	100	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1537	104	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1538	96	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1539	85	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1540	78	10000	stock_in	2025-08-21 00:03:38.1667	\N
2	1541	79	10000	stock_in	2025-08-21 00:03:38.1667	\N
1	1542	13	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1543	38	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1544	43	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1545	51	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1546	17	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1547	53	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1548	41	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1549	44	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1550	21	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1551	33	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1552	36	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1553	49	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1554	34	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1555	9	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1556	15	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1557	4	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1558	45	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1559	39	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1560	16	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1561	28	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1562	37	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1563	11	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1564	48	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1565	1	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1566	30	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1567	2	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1568	35	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1569	12	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1570	3	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1571	22	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1572	52	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1573	19	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1574	32	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1575	27	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1576	18	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1577	29	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1578	40	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1579	10	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1580	54	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1581	14	100	stock_in	2025-08-21 00:07:13.173123	\N
1	1582	20	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1583	5	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1584	8	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1585	23	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1586	6	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1587	47	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1588	26	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1589	7	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1590	55	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1591	46	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1592	50	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1593	42	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1594	31	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1595	24	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1596	25	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1597	68	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1598	92	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1599	97	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1600	105	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1601	71	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1602	107	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1603	95	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1604	98	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1605	75	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1606	87	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1607	90	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1608	103	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1609	88	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1610	64	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1611	69	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1612	59	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1613	99	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1614	93	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1615	70	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1616	82	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1617	91	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1618	66	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1619	102	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1620	56	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1621	84	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1622	57	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1623	89	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1624	67	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1625	58	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1626	76	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1627	106	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1628	73	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1629	86	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1630	81	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1631	72	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1632	83	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1633	94	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1634	65	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1635	108	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1636	110	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1637	74	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1638	60	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1639	63	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1640	77	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1641	61	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1642	101	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1643	80	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1644	62	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1645	109	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1646	100	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1647	104	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1648	96	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1649	85	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1650	78	10000	stock_in	2025-08-21 00:07:13.173123	\N
2	1651	79	10000	stock_in	2025-08-21 00:07:13.173123	\N
1	1652	13	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1653	38	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1654	43	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1655	51	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1656	17	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1657	53	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1658	41	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1659	44	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1660	21	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1661	33	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1662	36	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1663	49	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1664	34	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1665	9	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1666	15	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1667	4	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1668	45	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1669	39	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1670	16	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1671	28	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1672	37	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1673	11	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1674	48	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1675	1	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1676	30	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1677	2	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1678	35	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1679	12	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1680	3	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1681	22	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1682	52	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1683	19	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1684	32	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1685	27	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1686	18	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1687	29	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1688	40	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1689	10	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1690	54	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1691	14	100	stock_in	2025-08-21 00:12:54.748897	\N
1	1692	20	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1693	5	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1694	8	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1695	23	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1696	6	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1697	47	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1698	26	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1699	7	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1700	55	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1701	46	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1702	50	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1703	42	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1704	31	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1705	24	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1706	25	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1707	68	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1708	92	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1709	97	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1710	105	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1711	71	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1712	107	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1713	95	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1714	98	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1715	75	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1716	87	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1717	90	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1718	103	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1719	88	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1720	64	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1721	69	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1722	59	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1723	99	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1724	93	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1725	70	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1726	82	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1727	91	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1728	66	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1729	102	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1730	56	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1731	84	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1732	57	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1733	89	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1734	67	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1735	58	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1736	76	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1737	106	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1738	73	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1739	86	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1740	81	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1741	72	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1742	83	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1743	94	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1744	65	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1745	108	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1746	110	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1747	74	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1748	60	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1749	63	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1750	77	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1751	61	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1752	101	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1753	80	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1754	62	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1755	109	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1756	100	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1757	104	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1758	96	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1759	85	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1760	78	10000	stock_in	2025-08-21 00:12:54.748897	\N
2	1761	79	10000	stock_in	2025-08-21 00:12:54.748897	\N
1	1762	13	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1763	38	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1764	43	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1765	51	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1766	17	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1767	53	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1768	41	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1769	44	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1770	21	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1771	33	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1772	36	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1773	49	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1774	34	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1775	9	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1776	15	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1777	4	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1778	45	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1779	39	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1780	16	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1781	28	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1782	37	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1783	11	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1784	48	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1785	1	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1786	30	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1787	2	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1788	35	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1789	12	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1790	3	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1791	22	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1792	52	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1793	19	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1794	32	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1795	27	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1796	18	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1797	29	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1798	40	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1799	10	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1800	54	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1801	14	100	stock_in	2025-08-21 00:18:01.73398	\N
1	1802	20	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1803	5	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1804	8	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1805	23	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1806	6	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1807	47	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1808	26	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1809	7	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1810	55	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1811	46	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1812	50	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1813	42	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1814	31	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1815	24	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1816	25	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1817	68	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1818	92	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1819	97	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1820	105	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1821	71	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1822	107	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1823	95	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1824	98	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1825	75	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1826	87	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1827	90	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1828	103	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1829	88	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1830	64	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1831	69	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1832	59	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1833	99	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1834	93	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1835	70	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1836	82	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1837	91	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1838	66	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1839	102	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1840	56	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1841	84	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1842	57	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1843	89	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1844	67	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1845	58	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1846	76	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1847	106	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1848	73	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1849	86	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1850	81	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1851	72	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1852	83	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1853	94	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1854	65	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1855	108	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1856	110	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1857	74	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1858	60	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1859	63	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1860	77	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1861	61	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1862	101	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1863	80	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1864	62	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1865	109	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1866	100	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1867	104	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1868	96	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1869	85	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1870	78	10000	stock_in	2025-08-21 00:18:01.73398	\N
2	1871	79	10000	stock_in	2025-08-21 00:18:01.73398	\N
1	1872	13	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1873	38	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1874	43	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1875	51	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1876	17	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1877	53	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1878	41	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1879	44	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1880	21	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1881	33	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1882	36	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1883	49	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1884	34	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1885	9	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1886	15	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1887	4	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1888	45	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1889	39	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1890	16	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1891	28	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1892	37	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1893	11	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1894	48	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1895	1	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1896	30	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1897	2	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1898	35	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1899	12	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1900	3	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1901	22	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1902	52	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1903	19	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1904	32	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1905	27	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1906	18	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1907	29	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1908	40	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1909	10	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1910	54	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1911	14	100	stock_in	2025-08-21 00:19:15.180983	\N
1	1912	20	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1913	5	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1914	8	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1915	23	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1916	6	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1917	47	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1918	26	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1919	7	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1920	55	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1921	46	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1922	50	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1923	42	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1924	31	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1925	24	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1926	25	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1927	68	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1928	92	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1929	97	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1930	105	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1931	71	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1932	107	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1933	95	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1934	98	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1935	75	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1936	87	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1937	90	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1938	103	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1939	88	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1940	64	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1941	69	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1942	59	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1943	99	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1944	93	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1945	70	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1946	82	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1947	91	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1948	66	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1949	102	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1950	56	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1951	84	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1952	57	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1953	89	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1954	67	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1955	58	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1956	76	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1957	106	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1958	73	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1959	86	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1960	81	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1961	72	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1962	83	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1963	94	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1964	65	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1965	108	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1966	110	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1967	74	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1968	60	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1969	63	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1970	77	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1971	61	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1972	101	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1973	80	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1974	62	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1975	109	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1976	100	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1977	104	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1978	96	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1979	85	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1980	78	10000	stock_in	2025-08-21 00:19:15.180983	\N
2	1981	79	10000	stock_in	2025-08-21 00:19:15.180983	\N
1	1982	1	3660.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1983	2	180.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1984	23	825.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1985	34	1600.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1986	46	850.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1987	44	170.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1988	31	7700.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1989	43	170.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1990	35	3200.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1991	42	2250.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1992	6	4530.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1993	25	910.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1994	8	440.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1995	20	1320.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1996	3	2280.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1997	4	120.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1998	5	480.0	stock_out	2025-08-21 00:39:41.441693	\N
1	1999	15	720.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2000	18	540.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2001	19	360.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2002	32	7000.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2003	33	3400.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2004	10	250.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2005	11	25.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2006	12	500.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2007	13	730.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2008	14	42.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2009	48	150.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2010	26	1200.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2011	21	300.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2012	22	1440.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2013	39	40.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2014	41	300.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2015	37	70.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2016	36	250.0	stock_out	2025-08-21 00:39:41.441693	\N
1	2017	47	400.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2018	103	410.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2019	98	4850.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2020	56	360.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2021	75	270.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2022	60	1100.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2023	58	870.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2024	59	175.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2025	82	800.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2026	79	1540.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2027	77	570.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2028	101	850.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2029	90	5250.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2030	89	1750.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2031	97	600.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2032	63	300.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2033	110	83.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2034	64	60.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2035	87	4160.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2036	92	20.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2037	85	1430.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2038	83	640.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2039	67	1040.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2040	88	2800.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2041	68	120.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2042	104	360.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2043	61	1800.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2044	57	120.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2045	69	90.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2046	72	90.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2047	91	100.0	stock_out	2025-08-21 00:39:41.441693	\N
2	2048	99	950.0	stock_out	2025-08-21 00:39:41.441693	\N
\.


--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 218
-- Name: kafka_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kafka_logs_log_id_seq', 329, true);


--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 223
-- Name: products_categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_categories_category_id_seq', 16, true);


--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 224
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 64, true);


--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 227
-- Name: raw_material_categories_rmc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.raw_material_categories_rmc_id_seq', 18, true);


--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 228
-- Name: raw_material_rm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.raw_material_rm_id_seq', 110, true);


--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 230
-- Name: recipes_recipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipes_recipe_id_seq', 1, false);


--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 232
-- Name: restaurants_r_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.restaurants_r_id_seq', 2, true);


--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 234
-- Name: sales_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_sale_id_seq', 196, true);


--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 237
-- Name: stock_movements_movement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stock_movements_movement_id_seq', 2048, true);


--
-- TOC entry 3301 (class 2606 OID 16489)
-- Name: kafka_logs kafka_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kafka_logs
    ADD CONSTRAINT kafka_logs_pkey PRIMARY KEY (r_id, log_id);


--
-- TOC entry 3325 (class 2606 OID 17164)
-- Name: kafka_logs_global kafka_logs_global_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kafka_logs_global
    ADD CONSTRAINT kafka_logs_global_pkey PRIMARY KEY (r_id, log_id);


--
-- TOC entry 3303 (class 2606 OID 16491)
-- Name: kafka_logs_rest1 kafka_logs_rest1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kafka_logs_rest1
    ADD CONSTRAINT kafka_logs_rest1_pkey PRIMARY KEY (r_id, log_id);


--
-- TOC entry 3305 (class 2606 OID 16493)
-- Name: kafka_logs_rest2 kafka_logs_rest2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kafka_logs_rest2
    ADD CONSTRAINT kafka_logs_rest2_pkey PRIMARY KEY (r_id, log_id);


--
-- TOC entry 3309 (class 2606 OID 16495)
-- Name: products_categories products_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products_categories
    ADD CONSTRAINT products_categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 3307 (class 2606 OID 16497)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 3313 (class 2606 OID 16499)
-- Name: raw_material_categories raw_material_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raw_material_categories
    ADD CONSTRAINT raw_material_categories_pkey PRIMARY KEY (rmc_id);


--
-- TOC entry 3311 (class 2606 OID 16501)
-- Name: raw_material raw_material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raw_material
    ADD CONSTRAINT raw_material_pkey PRIMARY KEY (rm_id);


--
-- TOC entry 3315 (class 2606 OID 16503)
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (recipe_id);


--
-- TOC entry 3317 (class 2606 OID 16505)
-- Name: restaurants restaurants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restaurants
    ADD CONSTRAINT restaurants_pkey PRIMARY KEY (r_id);


--
-- TOC entry 3319 (class 2606 OID 16507)
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (sale_id);


--
-- TOC entry 3323 (class 2606 OID 16509)
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (movement_id);


--
-- TOC entry 3321 (class 2606 OID 16511)
-- Name: stock stock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (r_id, rm_id);


--
-- TOC entry 3328 (class 0 OID 0)
-- Name: kafka_logs_global_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.kafka_logs_pkey ATTACH PARTITION public.kafka_logs_global_pkey;


--
-- TOC entry 3326 (class 0 OID 0)
-- Name: kafka_logs_rest1_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.kafka_logs_pkey ATTACH PARTITION public.kafka_logs_rest1_pkey;


--
-- TOC entry 3327 (class 0 OID 0)
-- Name: kafka_logs_rest2_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.kafka_logs_pkey ATTACH PARTITION public.kafka_logs_rest2_pkey;


--
-- TOC entry 3329 (class 2606 OID 16518)
-- Name: kafka_logs kafka_logs_r_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.kafka_logs
    ADD CONSTRAINT kafka_logs_r_id_fkey FOREIGN KEY (r_id) REFERENCES public.restaurants(r_id);


--
-- TOC entry 3330 (class 2606 OID 16529)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.products_categories(category_id);


--
-- TOC entry 3331 (class 2606 OID 16534)
-- Name: products products_r_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_r_id_fkey FOREIGN KEY (r_id) REFERENCES public.restaurants(r_id);


--
-- TOC entry 3332 (class 2606 OID 16539)
-- Name: raw_material raw_material_r_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raw_material
    ADD CONSTRAINT raw_material_r_id_fkey FOREIGN KEY (r_id) REFERENCES public.restaurants(r_id);


--
-- TOC entry 3333 (class 2606 OID 16544)
-- Name: raw_material raw_material_rm_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.raw_material
    ADD CONSTRAINT raw_material_rm_category_fkey FOREIGN KEY (rm_category) REFERENCES public.raw_material_categories(rmc_id);


--
-- TOC entry 3334 (class 2606 OID 16549)
-- Name: recipes recipes_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 3335 (class 2606 OID 16554)
-- Name: recipes recipes_r_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_r_id_fkey FOREIGN KEY (r_id) REFERENCES public.restaurants(r_id);


--
-- TOC entry 3336 (class 2606 OID 16559)
-- Name: recipes recipes_rm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_rm_id_fkey FOREIGN KEY (rm_id) REFERENCES public.raw_material(rm_id);


--
-- TOC entry 3337 (class 2606 OID 16564)
-- Name: sales sales_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 3338 (class 2606 OID 16569)
-- Name: sales sales_r_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_r_id_fkey FOREIGN KEY (r_id) REFERENCES public.restaurants(r_id);


--
-- TOC entry 3341 (class 2606 OID 16574)
-- Name: stock_movements stock_movements_r_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_r_id_fkey FOREIGN KEY (r_id) REFERENCES public.restaurants(r_id);


--
-- TOC entry 3342 (class 2606 OID 16579)
-- Name: stock_movements stock_movements_rm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_rm_id_fkey FOREIGN KEY (rm_id) REFERENCES public.raw_material(rm_id);


--
-- TOC entry 3339 (class 2606 OID 16589)
-- Name: stock stock_r_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_r_id_fkey FOREIGN KEY (r_id) REFERENCES public.restaurants(r_id);


--
-- TOC entry 3340 (class 2606 OID 16594)
-- Name: stock stock_rm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_rm_id_fkey FOREIGN KEY (rm_id) REFERENCES public.raw_material(rm_id);


-- Completed on 2025-08-21 01:37:40 UTC

--
-- PostgreSQL database dump complete
--

