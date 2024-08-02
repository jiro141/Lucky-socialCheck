SET check_function_bodies = false;
CREATE SCHEMA social_gifts;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE FUNCTION social_gifts.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE social_gifts.account (
    id integer NOT NULL,
    id_bag uuid NOT NULL,
    id_service integer NOT NULL,
    id_ref text NOT NULL,
    details jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
COMMENT ON TABLE social_gifts.account IS 'This table relates wallets with user accounts by service.';
CREATE SEQUENCE social_gifts.account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE social_gifts.account_id_seq OWNED BY social_gifts.account.id;
CREATE TABLE social_gifts.lucky_bag (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    public_key text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);
COMMENT ON TABLE social_gifts.lucky_bag IS 'This table will be used to record all wallets that request welcome gifts.';
CREATE TABLE social_gifts.reward (
    id integer NOT NULL,
    id_account integer NOT NULL,
    id_task integer NOT NULL,
    claimed boolean DEFAULT false,
    details jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
COMMENT ON TABLE social_gifts.reward IS 'This table stores the tasks completed by the user.';
CREATE SEQUENCE social_gifts.reward_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE social_gifts.reward_id_seq OWNED BY social_gifts.reward.id;
CREATE TABLE social_gifts.service (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    url text NOT NULL,
    config jsonb DEFAULT jsonb_build_object(),
    metadata jsonb DEFAULT jsonb_build_object(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
COMMENT ON TABLE social_gifts.service IS 'This table will store the types of services which users can use.';
CREATE SEQUENCE social_gifts.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE social_gifts.services_id_seq OWNED BY social_gifts.service.id;
CREATE TABLE social_gifts.task (
    id integer NOT NULL,
    id_service integer NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    mint text NOT NULL,
    amount bigint NOT NULL,
    metadata jsonb DEFAULT jsonb_build_object(),
    "position" integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
COMMENT ON TABLE social_gifts.task IS 'This table will store the tasks that the user can complete to obtain a reward.';
CREATE SEQUENCE social_gifts.task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE social_gifts.task_id_seq OWNED BY social_gifts.task.id;
ALTER TABLE ONLY social_gifts.account ALTER COLUMN id SET DEFAULT nextval('social_gifts.account_id_seq'::regclass);
ALTER TABLE ONLY social_gifts.reward ALTER COLUMN id SET DEFAULT nextval('social_gifts.reward_id_seq'::regclass);
ALTER TABLE ONLY social_gifts.service ALTER COLUMN id SET DEFAULT nextval('social_gifts.services_id_seq'::regclass);
ALTER TABLE ONLY social_gifts.task ALTER COLUMN id SET DEFAULT nextval('social_gifts.task_id_seq'::regclass);
ALTER TABLE ONLY social_gifts.account
    ADD CONSTRAINT account_id_ref_id_service_key UNIQUE (id_ref, id_service);
ALTER TABLE ONLY social_gifts.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);
ALTER TABLE ONLY social_gifts.lucky_bag
    ADD CONSTRAINT lucky_bag_pkey PRIMARY KEY (id);
ALTER TABLE ONLY social_gifts.lucky_bag
    ADD CONSTRAINT lucky_bag_public_key_key UNIQUE (public_key);
ALTER TABLE ONLY social_gifts.reward
    ADD CONSTRAINT reward_pkey PRIMARY KEY (id);
ALTER TABLE ONLY social_gifts.service
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);
ALTER TABLE ONLY social_gifts.service
    ADD CONSTRAINT services_slug_key UNIQUE (slug);
ALTER TABLE ONLY social_gifts.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);
CREATE TRIGGER set_social_gifts_reward_updated_at BEFORE UPDATE ON social_gifts.reward FOR EACH ROW EXECUTE FUNCTION social_gifts.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_social_gifts_reward_updated_at ON social_gifts.reward IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_social_gifts_service_updated_at BEFORE UPDATE ON social_gifts.service FOR EACH ROW EXECUTE FUNCTION social_gifts.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_social_gifts_service_updated_at ON social_gifts.service IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_social_gifts_task_updated_at BEFORE UPDATE ON social_gifts.task FOR EACH ROW EXECUTE FUNCTION social_gifts.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_social_gifts_task_updated_at ON social_gifts.task IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY social_gifts.account
    ADD CONSTRAINT account_id_bag_fkey FOREIGN KEY (id_bag) REFERENCES social_gifts.lucky_bag(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY social_gifts.account
    ADD CONSTRAINT account_id_service_fkey FOREIGN KEY (id_service) REFERENCES social_gifts.service(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY social_gifts.reward
    ADD CONSTRAINT reward_id_account_fkey FOREIGN KEY (id_account) REFERENCES social_gifts.account(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY social_gifts.reward
    ADD CONSTRAINT reward_id_task_fkey FOREIGN KEY (id_task) REFERENCES social_gifts.task(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY social_gifts.task
    ADD CONSTRAINT task_id_service_fkey FOREIGN KEY (id_service) REFERENCES social_gifts.service(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
