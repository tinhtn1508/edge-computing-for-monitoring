--
-- Name: config; Type: TABLE; Schema: public; Owner: catalog
--

CREATE TABLE public.config (
    id SERIAL NOT NULL PRIMARY KEY,
    key character varying(255),
    value jsonb
);

ALTER TABLE public.config OWNER TO catalog;


