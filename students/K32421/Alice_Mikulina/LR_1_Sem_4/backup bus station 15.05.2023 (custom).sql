PGDMP       .    %                {            bus station    11.19    11.19 R    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    16384    bus station    DATABASE     �   CREATE DATABASE "bus station" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Russian_Russia.1251' LC_CTYPE = 'Russian_Russia.1251';
    DROP DATABASE "bus station";
             postgres    false            �           0    0    DATABASE "bus station"    COMMENT     L   COMMENT ON DATABASE "bus station" IS 'a database for ICT course 2022-2023';
                  postgres    false    2967                        2615    16385    bs    SCHEMA        CREATE SCHEMA bs;
    DROP SCHEMA bs;
             postgres    false            �            1255    24728    update_seat_number()    FUNCTION     �   CREATE FUNCTION public.update_seat_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  seat_number INT;
BEGIN
  SELECT num_seat INTO seat_number FROM bs.seat WHERE id = NEW.seat_id;
  NEW.seat_number := seat_number;
  RETURN NEW;
END;
$$;
 +   DROP FUNCTION public.update_seat_number();
       public       postgres    false            �            1259    24599    bus    TABLE     �   CREATE TABLE bs.bus (
    number integer NOT NULL,
    type_id integer NOT NULL,
    state_num character(128) NOT NULL,
    manufacture_year integer NOT NULL,
    CONSTRAINT manufacture_year_constraint CHECK ((manufacture_year >= 1920))
);
    DROP TABLE bs.bus;
       bs         postgres    false    8            �            1259    24597    bus_number_seq    SEQUENCE     �   ALTER TABLE bs.bus ALTER COLUMN number ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.bus_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    210    8            �            1259    16645    bus_stop    TABLE     �   CREATE TABLE bs.bus_stop (
    id integer NOT NULL,
    address character varying(256) NOT NULL,
    name character varying(128) NOT NULL
);
    DROP TABLE bs.bus_stop;
       bs         postgres    false    8            �            1259    16643    bus_stop_id_seq    SEQUENCE     �   ALTER TABLE bs.bus_stop ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.bus_stop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    206    8            �            1259    16582    bus_type    TABLE     �  CREATE TABLE bs.bus_type (
    id integer NOT NULL,
    size character varying(20) DEFAULT 'average'::character varying NOT NULL,
    luggage_compartment character varying(3) NOT NULL,
    toilet character varying(3) NOT NULL,
    num_seats integer NOT NULL,
    brand character varying(128),
    manufacturer character varying(128),
    manufacturer_country character varying(128),
    CONSTRAINT bus_type_luggage_compartment_check CHECK (((luggage_compartment)::text = ANY ((ARRAY['yes'::character varying, 'no'::character varying])::text[]))),
    CONSTRAINT bus_type_size_check CHECK (((size)::text = ANY ((ARRAY['very small'::character varying, 'small'::character varying, 'average'::character varying, 'big'::character varying, 'very big'::character varying])::text[]))),
    CONSTRAINT bus_type_toilet_check CHECK (((toilet)::text = ANY ((ARRAY['yes'::character varying, 'no'::character varying])::text[])))
);
    DROP TABLE bs.bus_type;
       bs         postgres    false    8            �            1259    16580    bus_type_id_seq    SEQUENCE     �   ALTER TABLE bs.bus_type ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.bus_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    8    202            �            1259    24612    crew    TABLE     X  CREATE TABLE bs.crew (
    id integer NOT NULL,
    med_exam_date timestamp without time zone NOT NULL,
    admission_status character varying(3) NOT NULL,
    driver_id integer NOT NULL,
    CONSTRAINT crew_admission_status_check CHECK (((admission_status)::text = ANY ((ARRAY['yes'::character varying, 'no'::character varying])::text[])))
);
    DROP TABLE bs.crew;
       bs         postgres    false    8            �            1259    24610    crew_id_seq    SEQUENCE     �   ALTER TABLE bs.crew ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.crew_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    212    8            �            1259    16535    driver    TABLE     �   CREATE TABLE bs.driver (
    id integer NOT NULL,
    full_name character(128) NOT NULL,
    passport character(256) NOT NULL,
    phone_number bigint,
    e_mail character(128)
);
    DROP TABLE bs.driver;
       bs         postgres    false    8            �            1259    16533    driver_id_seq    SEQUENCE     �   ALTER TABLE bs.driver ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.driver_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    198    8            �            1259    24625    flight    TABLE       CREATE TABLE bs.flight (
    number integer NOT NULL,
    date timestamp without time zone NOT NULL,
    departure_time time without time zone NOT NULL,
    arrival_time time without time zone NOT NULL,
    status character(128),
    bus_num integer NOT NULL,
    crew_id integer NOT NULL,
    route_id integer NOT NULL,
    CONSTRAINT arrival_departure_time_constraint CHECK ((departure_time < arrival_time)),
    CONSTRAINT flight_date_check CHECK ((date >= '2010-01-01 00:00:00'::timestamp without time zone))
);
    DROP TABLE bs.flight;
       bs         postgres    false    8            �            1259    24623    flight_number_seq    SEQUENCE     �   ALTER TABLE bs.flight ALTER COLUMN number ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.flight_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    214    8            �            1259    16551 	   passenger    TABLE     �   CREATE TABLE bs.passenger (
    id integer NOT NULL,
    full_name character(128) NOT NULL,
    passport character(256) NOT NULL,
    phone_number bigint,
    e_mail character(128)
);
    DROP TABLE bs.passenger;
       bs         postgres    false    8            �            1259    16549    passenger_id_seq    SEQUENCE     �   ALTER TABLE bs.passenger ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.passenger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    8    200            �            1259    16631    route    TABLE     ~  CREATE TABLE bs.route (
    id integer NOT NULL,
    weekdays text[] NOT NULL,
    distance_status character varying(13) NOT NULL,
    departure_time time without time zone NOT NULL,
    travel_time interval NOT NULL,
    departure_point character varying(128) NOT NULL,
    arrival_point character varying(128) NOT NULL,
    distance integer NOT NULL,
    CONSTRAINT distance_constraint CHECK ((distance > 0)),
    CONSTRAINT route_departure_time_check CHECK (((departure_time >= '00:00:00'::time without time zone) AND (departure_time <= '23:59:59'::time without time zone))),
    CONSTRAINT route_distance_status_check CHECK (((distance_status)::text = ANY ((ARRAY['urban'::character varying, 'suburban'::character varying, 'intercity'::character varying, 'international'::character varying])::text[]))),
    CONSTRAINT travel_time_constraint CHECK ((travel_time > '00:00:00'::interval))
);
    DROP TABLE bs.route;
       bs         postgres    false    8            �            1259    16629    route_id_seq    SEQUENCE     �   ALTER TABLE bs.route ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.route_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    8    204            �            1259    24675    seat    TABLE     3  CREATE TABLE bs.seat (
    id integer NOT NULL,
    num_seat integer NOT NULL,
    taken_status character varying(3) NOT NULL,
    flight_id integer NOT NULL,
    CONSTRAINT seat_taken_status_check CHECK (((taken_status)::text = ANY ((ARRAY['yes'::character varying, 'no'::character varying])::text[])))
);
    DROP TABLE bs.seat;
       bs         postgres    false    8            �            1259    24673    seat_id_seq    SEQUENCE     �   ALTER TABLE bs.seat ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.seat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    8    216            �            1259    24732    ticket    TABLE     }  CREATE TABLE bs.ticket (
    number integer NOT NULL,
    departure_time time without time zone NOT NULL,
    arrival_time time without time zone NOT NULL,
    cancellation_status character(3) NOT NULL,
    purchase_type character(7) NOT NULL,
    flight_num integer NOT NULL,
    passenger_id integer NOT NULL,
    departure_stop_id integer NOT NULL,
    arrival_stop_id integer NOT NULL,
    cost integer NOT NULL,
    seat_id integer NOT NULL,
    seat_number integer NOT NULL,
    CONSTRAINT departure_arrival_stops_constraint CHECK ((departure_stop_id <> arrival_stop_id)),
    CONSTRAINT ticket_cancellation_status_check CHECK ((cancellation_status = ANY (ARRAY['yes'::bpchar, 'no'::bpchar]))),
    CONSTRAINT ticket_purchase_type_check CHECK ((purchase_type = ANY (ARRAY['online'::bpchar, 'offline'::bpchar]))),
    CONSTRAINT time_constraint CHECK ((departure_time < arrival_time))
);
    DROP TABLE bs.ticket;
       bs         postgres    false    8            �            1259    24730    ticket_number_seq    SEQUENCE     �   ALTER TABLE bs.ticket ALTER COLUMN number ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.ticket_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    8    218            �            1259    24578    way_stop    TABLE     �  CREATE TABLE bs.way_stop (
    id integer NOT NULL,
    global_id integer NOT NULL,
    route_id integer NOT NULL,
    departure_time time without time zone NOT NULL,
    arrival_time time without time zone NOT NULL,
    duration interval NOT NULL,
    CONSTRAINT arrival_departure_constraint CHECK ((arrival_time <= departure_time)),
    CONSTRAINT duration_constraint CHECK ((duration >= '00:00:00'::interval)),
    CONSTRAINT way_stop_departure_time_check CHECK (((departure_time >= '00:00:00'::time without time zone) AND (departure_time <= '23:59:59'::time without time zone))),
    CONSTRAINT way_stop_departure_time_check1 CHECK (((departure_time >= '00:00:00'::time without time zone) AND (departure_time <= '23:59:59'::time without time zone)))
);
    DROP TABLE bs.way_stop;
       bs         postgres    false    8            �            1259    24576    way_stop_id_seq    SEQUENCE     �   ALTER TABLE bs.way_stop ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bs.way_stop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            bs       postgres    false    208    8            �          0    24599    bus 
   TABLE DATA               G   COPY bs.bus (number, type_id, state_num, manufacture_year) FROM stdin;
    bs       postgres    false    210   �h       �          0    16645    bus_stop 
   TABLE DATA               1   COPY bs.bus_stop (id, address, name) FROM stdin;
    bs       postgres    false    206   Br       �          0    16582    bus_type 
   TABLE DATA               {   COPY bs.bus_type (id, size, luggage_compartment, toilet, num_seats, brand, manufacturer, manufacturer_country) FROM stdin;
    bs       postgres    false    202   �u       �          0    24612    crew 
   TABLE DATA               J   COPY bs.crew (id, med_exam_date, admission_status, driver_id) FROM stdin;
    bs       postgres    false    212   �y       }          0    16535    driver 
   TABLE DATA               K   COPY bs.driver (id, full_name, passport, phone_number, e_mail) FROM stdin;
    bs       postgres    false    198   �{       �          0    24625    flight 
   TABLE DATA               l   COPY bs.flight (number, date, departure_time, arrival_time, status, bus_num, crew_id, route_id) FROM stdin;
    bs       postgres    false    214   n�                 0    16551 	   passenger 
   TABLE DATA               N   COPY bs.passenger (id, full_name, passport, phone_number, e_mail) FROM stdin;
    bs       postgres    false    200   J�       �          0    16631    route 
   TABLE DATA               �   COPY bs.route (id, weekdays, distance_status, departure_time, travel_time, departure_point, arrival_point, distance) FROM stdin;
    bs       postgres    false    204   ��       �          0    24675    seat 
   TABLE DATA               A   COPY bs.seat (id, num_seat, taken_status, flight_id) FROM stdin;
    bs       postgres    false    216   ߰       �          0    24732    ticket 
   TABLE DATA               �   COPY bs.ticket (number, departure_time, arrival_time, cancellation_status, purchase_type, flight_num, passenger_id, departure_stop_id, arrival_stop_id, cost, seat_id, seat_number) FROM stdin;
    bs       postgres    false    218   ��       �          0    24578    way_stop 
   TABLE DATA               _   COPY bs.way_stop (id, global_id, route_id, departure_time, arrival_time, duration) FROM stdin;
    bs       postgres    false    208   �       �           0    0    bus_number_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('bs.bus_number_seq', 17, true);
            bs       postgres    false    209            �           0    0    bus_stop_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('bs.bus_stop_id_seq', 20, true);
            bs       postgres    false    205            �           0    0    bus_type_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('bs.bus_type_id_seq', 18, true);
            bs       postgres    false    201            �           0    0    crew_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('bs.crew_id_seq', 16, true);
            bs       postgres    false    211            �           0    0    driver_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('bs.driver_id_seq', 16, true);
            bs       postgres    false    197            �           0    0    flight_number_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('bs.flight_number_seq', 25, true);
            bs       postgres    false    213            �           0    0    passenger_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('bs.passenger_id_seq', 2, true);
            bs       postgres    false    199            �           0    0    route_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('bs.route_id_seq', 7, true);
            bs       postgres    false    203            �           0    0    seat_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('bs.seat_id_seq', 12, true);
            bs       postgres    false    215            �           0    0    ticket_number_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('bs.ticket_number_seq', 6, true);
            bs       postgres    false    217            �           0    0    way_stop_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('bs.way_stop_id_seq', 3, true);
            bs       postgres    false    207            �
           2606    24604    bus bus_number_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY bs.bus
    ADD CONSTRAINT bus_number_pkey PRIMARY KEY (number);
 9   ALTER TABLE ONLY bs.bus DROP CONSTRAINT bus_number_pkey;
       bs         postgres    false    210            �
           2606    16649    bus_stop bus_stop_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY bs.bus_stop
    ADD CONSTRAINT bus_stop_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY bs.bus_stop DROP CONSTRAINT bus_stop_pkey;
       bs         postgres    false    206            �
           2606    16590    bus_type bus_type_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY bs.bus_type
    ADD CONSTRAINT bus_type_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY bs.bus_type DROP CONSTRAINT bus_type_pkey;
       bs         postgres    false    202            �
           2606    24617    crew crew_pkey 
   CONSTRAINT     H   ALTER TABLE ONLY bs.crew
    ADD CONSTRAINT crew_pkey PRIMARY KEY (id);
 4   ALTER TABLE ONLY bs.crew DROP CONSTRAINT crew_pkey;
       bs         postgres    false    212            �
           2606    16542    driver driver_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY bs.driver
    ADD CONSTRAINT driver_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY bs.driver DROP CONSTRAINT driver_pkey;
       bs         postgres    false    198            �
           2606    24631    flight flight_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY bs.flight
    ADD CONSTRAINT flight_pkey PRIMARY KEY (number);
 8   ALTER TABLE ONLY bs.flight DROP CONSTRAINT flight_pkey;
       bs         postgres    false    214            �
           2606    16558    passenger passenger_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY bs.passenger
    ADD CONSTRAINT passenger_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY bs.passenger DROP CONSTRAINT passenger_pkey;
       bs         postgres    false    200            �
           2606    16642    route route_pkey 
   CONSTRAINT     J   ALTER TABLE ONLY bs.route
    ADD CONSTRAINT route_pkey PRIMARY KEY (id);
 6   ALTER TABLE ONLY bs.route DROP CONSTRAINT route_pkey;
       bs         postgres    false    204            �
           2606    24680    seat seat_pkey 
   CONSTRAINT     H   ALTER TABLE ONLY bs.seat
    ADD CONSTRAINT seat_pkey PRIMARY KEY (id);
 4   ALTER TABLE ONLY bs.seat DROP CONSTRAINT seat_pkey;
       bs         postgres    false    216            �
           2606    24740    ticket ticket_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY bs.ticket
    ADD CONSTRAINT ticket_pkey PRIMARY KEY (number);
 8   ALTER TABLE ONLY bs.ticket DROP CONSTRAINT ticket_pkey;
       bs         postgres    false    218            �
           2606    16544    driver unique_d_email 
   CONSTRAINT     N   ALTER TABLE ONLY bs.driver
    ADD CONSTRAINT unique_d_email UNIQUE (e_mail);
 ;   ALTER TABLE ONLY bs.driver DROP CONSTRAINT unique_d_email;
       bs         postgres    false    198            �
           2606    16546    driver unique_d_passport 
   CONSTRAINT     S   ALTER TABLE ONLY bs.driver
    ADD CONSTRAINT unique_d_passport UNIQUE (passport);
 >   ALTER TABLE ONLY bs.driver DROP CONSTRAINT unique_d_passport;
       bs         postgres    false    198            �
           2606    16548    driver unique_d_phone 
   CONSTRAINT     T   ALTER TABLE ONLY bs.driver
    ADD CONSTRAINT unique_d_phone UNIQUE (phone_number);
 ;   ALTER TABLE ONLY bs.driver DROP CONSTRAINT unique_d_phone;
       bs         postgres    false    198            �
           2606    16560    passenger unique_p_email 
   CONSTRAINT     Q   ALTER TABLE ONLY bs.passenger
    ADD CONSTRAINT unique_p_email UNIQUE (e_mail);
 >   ALTER TABLE ONLY bs.passenger DROP CONSTRAINT unique_p_email;
       bs         postgres    false    200            �
           2606    16562    passenger unique_p_passport 
   CONSTRAINT     V   ALTER TABLE ONLY bs.passenger
    ADD CONSTRAINT unique_p_passport UNIQUE (passport);
 A   ALTER TABLE ONLY bs.passenger DROP CONSTRAINT unique_p_passport;
       bs         postgres    false    200            �
           2606    16564    passenger unique_p_phone 
   CONSTRAINT     W   ALTER TABLE ONLY bs.passenger
    ADD CONSTRAINT unique_p_phone UNIQUE (phone_number);
 >   ALTER TABLE ONLY bs.passenger DROP CONSTRAINT unique_p_phone;
       bs         postgres    false    200            �
           2606    24586    way_stop way_stop_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY bs.way_stop
    ADD CONSTRAINT way_stop_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY bs.way_stop DROP CONSTRAINT way_stop_pkey;
       bs         postgres    false    208                       2620    24766    ticket seatnumbertrigger    TRIGGER     x   CREATE TRIGGER seatnumbertrigger BEFORE INSERT ON bs.ticket FOR EACH ROW EXECUTE PROCEDURE public.update_seat_number();
 -   DROP TRIGGER seatnumbertrigger ON bs.ticket;
       bs       postgres    false    218    219            �
           2606    24605    bus bus_type_id_fkey    FK CONSTRAINT     n   ALTER TABLE ONLY bs.bus
    ADD CONSTRAINT bus_type_id_fkey FOREIGN KEY (type_id) REFERENCES bs.bus_type(id);
 :   ALTER TABLE ONLY bs.bus DROP CONSTRAINT bus_type_id_fkey;
       bs       postgres    false    2788    202    210            �
           2606    24618    crew crew_driver_id_fkey    FK CONSTRAINT     r   ALTER TABLE ONLY bs.crew
    ADD CONSTRAINT crew_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES bs.driver(id);
 >   ALTER TABLE ONLY bs.crew DROP CONSTRAINT crew_driver_id_fkey;
       bs       postgres    false    212    198    2772            �
           2606    24632    flight flight_bus_num_fkey    FK CONSTRAINT     s   ALTER TABLE ONLY bs.flight
    ADD CONSTRAINT flight_bus_num_fkey FOREIGN KEY (bus_num) REFERENCES bs.bus(number);
 @   ALTER TABLE ONLY bs.flight DROP CONSTRAINT flight_bus_num_fkey;
       bs       postgres    false    214    2796    210            �
           2606    24637    flight flight_crew_id_fkey    FK CONSTRAINT     p   ALTER TABLE ONLY bs.flight
    ADD CONSTRAINT flight_crew_id_fkey FOREIGN KEY (crew_id) REFERENCES bs.crew(id);
 @   ALTER TABLE ONLY bs.flight DROP CONSTRAINT flight_crew_id_fkey;
       bs       postgres    false    214    212    2798            �
           2606    24642    flight flight_route_id_fkey    FK CONSTRAINT     s   ALTER TABLE ONLY bs.flight
    ADD CONSTRAINT flight_route_id_fkey FOREIGN KEY (route_id) REFERENCES bs.route(id);
 A   ALTER TABLE ONLY bs.flight DROP CONSTRAINT flight_route_id_fkey;
       bs       postgres    false    2790    204    214            �
           2606    24681    seat seat_flight_id_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY bs.seat
    ADD CONSTRAINT seat_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES bs.flight(number);
 >   ALTER TABLE ONLY bs.seat DROP CONSTRAINT seat_flight_id_fkey;
       bs       postgres    false    216    2800    214                        2606    24756 "   ticket ticket_arrival_stop_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY bs.ticket
    ADD CONSTRAINT ticket_arrival_stop_id_fkey FOREIGN KEY (arrival_stop_id) REFERENCES bs.bus_stop(id);
 H   ALTER TABLE ONLY bs.ticket DROP CONSTRAINT ticket_arrival_stop_id_fkey;
       bs       postgres    false    206    218    2792            �
           2606    24751 $   ticket ticket_departure_stop_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY bs.ticket
    ADD CONSTRAINT ticket_departure_stop_id_fkey FOREIGN KEY (departure_stop_id) REFERENCES bs.bus_stop(id);
 J   ALTER TABLE ONLY bs.ticket DROP CONSTRAINT ticket_departure_stop_id_fkey;
       bs       postgres    false    206    218    2792            �
           2606    24741    ticket ticket_flight_num_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY bs.ticket
    ADD CONSTRAINT ticket_flight_num_fkey FOREIGN KEY (flight_num) REFERENCES bs.flight(number);
 C   ALTER TABLE ONLY bs.ticket DROP CONSTRAINT ticket_flight_num_fkey;
       bs       postgres    false    214    218    2800            �
           2606    24746    ticket ticket_passenger_id_fkey    FK CONSTRAINT        ALTER TABLE ONLY bs.ticket
    ADD CONSTRAINT ticket_passenger_id_fkey FOREIGN KEY (passenger_id) REFERENCES bs.passenger(id);
 E   ALTER TABLE ONLY bs.ticket DROP CONSTRAINT ticket_passenger_id_fkey;
       bs       postgres    false    200    218    2780                       2606    24761    ticket ticket_seat_id_fkey    FK CONSTRAINT     p   ALTER TABLE ONLY bs.ticket
    ADD CONSTRAINT ticket_seat_id_fkey FOREIGN KEY (seat_id) REFERENCES bs.seat(id);
 @   ALTER TABLE ONLY bs.ticket DROP CONSTRAINT ticket_seat_id_fkey;
       bs       postgres    false    216    218    2802            �
           2606    24587     way_stop way_stop_global_id_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY bs.way_stop
    ADD CONSTRAINT way_stop_global_id_fkey FOREIGN KEY (global_id) REFERENCES bs.bus_stop(id);
 F   ALTER TABLE ONLY bs.way_stop DROP CONSTRAINT way_stop_global_id_fkey;
       bs       postgres    false    208    206    2792            �
           2606    24592    way_stop way_stop_route_id_fkey    FK CONSTRAINT     w   ALTER TABLE ONLY bs.way_stop
    ADD CONSTRAINT way_stop_route_id_fkey FOREIGN KEY (route_id) REFERENCES bs.route(id);
 E   ALTER TABLE ONLY bs.way_stop DROP CONSTRAINT way_stop_route_id_fkey;
       bs       postgres    false    208    2790    204            �   �   1	1	ABC123                                                                                                                          	2015
 �   2	3	XYZ789                                                                                                                          	2018
 �   3	4	GHI456                                                                                                                          	2020
 �   4	5	JKL321                                                                                                                          	2016
 �   5	6	MNO654                                                                                                                          	2019
 �   6	7	PQR987                                                                                                                          	2017
 �   7	8	STU246                                                                                                                          	2014
 �   8	9	VWX369                                                                                                                          	2013
 �   9	10	YUI852                                                                                                                          	2012
 �   10	11	ZXC741                                                                                                                          	2011
 �   11	12	POI098                                                                                                                          	2010
 �   12	13	LKJ765                                                                                                                          	2009
 �   13	14	HGF432                                                                                                                          	2008
 �   14	15	EDC159                                                                                                                          	2007
 �   15	16	QAZ246                                                                                                                          	2006
 �   16	17	WSX369                                                                                                                          	2005
 �   17	18	RFV852                                                                                                                          	2004
    \.


      �   %   1	123 Main St.	Main St. and 1st Ave.
 #   2	456 Elm St.	Elm St. and 2nd Ave.
 #   3	789 Oak St.	Oak St. and 3rd Ave.
 (   4	1011 Maple St.	Maple St. and 4th Ave.
 &   5	1213 Pine St.	Pine St. and 5th Ave.
 (   6	1415 Cedar St.	Cedar St. and 6th Ave.
 (   7	1617 Birch St.	Birch St. and 7th Ave.
 *   8	1819 Walnut St.	Walnut St. and 8th Ave.
 *   9	2021 Cherry St.	Cherry St. and 9th Ave.
 ,   10	2223 Poplar St.	Poplar St. and 10th Ave.
 0   11	2425 Chestnut St.	Chestnut St. and 11th Ave.
 ,   12	2627 Spruce St.	Spruce St. and 12th Ave.
 0   13	2829 Sycamore St.	Sycamore St. and 13th Ave.
 (   14	3031 Pine St.	Pine St. and 14th Ave.
 *   15	3233 Maple St.	Maple St. and 15th Ave.
 &   16	3435 Oak St.	Oak St. and 16th Ave.
 &   17	3637 Elm St.	Elm St. and 17th Ave.
 (   18	3839 Main St.	Main St. and 18th Ave.
 ,   19	4041 Walnut St.	Walnut St. and 19th Ave.
 ,   20	4243 Cherry St.	Cherry St. and 20th Ave.
    \.


      �   -   1	big	yes	yes	50	Mercedes	Daimler AG	Germany
 .   3	average	yes	yes	30	Volvo	Volvo Buses	Sweden
 C   4	small	no	no	20	Volkswagen	Volkswagen Commercial Vehicles	Germany
 .   5	very big	yes	yes	75	Scania	Scania AB	Sweden
 /   6	average	no	no	40	MAN	MAN Truck & Bus	Germany
 '   7	big	yes	yes	55	Iveco	Iveco Bus	Italy
 5   8	average	yes	no	35	Neoplan	Neoplan Bus GmbH	Germany
 ,   9	small	no	no	25	Opel	Opel/Vauxhall	Germany
 3   10	very small	no	no	15	Peugeot	Peugeot S.A.	France
 8   11	big	yes	yes	60	Setra	Setra Buses and Coaches	Germany
 5   12	average	yes	yes	30	Van Hool	Van Hool N.V.	Belgium
 C   13	big	yes	yes	65	Dennis	Dennis Specialist Vehicles	United Kingdom
 >   14	average	no	no	40	Ashok Leyland	Ashok Leyland Limited	India
 9   15	very big	yes	yes	80	MCI	Motor Coach Industries	Canada
 8   16	average	yes	yes	35	Orion	Orion Bus Industries	Canada
 0   17	very small	no	no	12	Isuzu	Isuzu Motors	Japan
 (   18	big	yes	yes	70	Bova	Bova	Netherlands
    \.


      �      1	2022-01-01 10:00:00	yes	1
    2	2022-01-02 11:00:00	no	2
    3	2022-01-03 12:00:00	yes	3
    4	2022-01-04 13:00:00	yes	4
    5	2022-01-05 14:00:00	no	5
    6	2022-01-06 15:00:00	no	6
    7	2022-01-07 16:00:00	yes	7
    8	2022-01-08 17:00:00	yes	8
    9	2022-01-09 18:00:00	yes	9
    10	2022-01-10 19:00:00	no	10
    11	2022-01-11 20:00:00	yes	11
    12	2022-01-12 21:00:00	no	12
    13	2022-01-13 22:00:00	yes	13
    14	2022-01-14 23:00:00	yes	14
    15	2022-01-15 10:00:00	no	15
    16	2022-01-16 01:00:00	yes	16
    \.


      }     1	Ivanov Matvey Sergeevich                                                                                                        	0987 654321, given in Saratov oblast                                                                                                                                                                                                                            	89198358347	mrjoulin@yandex.ru                                                                                                              
   2	Ivan Ivanov                                                                                                                     	1234567890                                                                                                                                                                                                                                                      	79123456789	ivanov@mail.com                                                                                                                 
   3	Dmitry Petrov                                                                                                                   	0987654321                                                                                                                                                                                                                                                      	79234567890	petrov@mail.com                                                                                                                 
   4	Sergey Sidorov                                                                                                                  	1111111111                                                                                                                                                                                                                                                      	79345678901	sidorov@mail.com                                                                                                                
   5	Maria Ivanova                                                                                                                   	2222222222                                                                                                                                                                                                                                                      	79456789012	ivanova@mail.com                                                                                                                
   6	Anna Petrova                                                                                                                    	3333333333                                                                                                                                                                                                                                                      	79567890123	petrova@mail.com                                                                                                                
   7	Olga Sidorova                                                                                                                   	4444444444                                                                                                                                                                                                                                                      	79678901234	sidorova@mail.com                                                                                                               
   8	Pavel Ivanov                                                                                                                    	5555555555                                                                                                                                                                                                                                                      	79789012345	pavel@mail.com                                                                                                                  
   9	Maxim Petrov                                                                                                                    	6666666666                                                                                                                                                                                                                                                      	79890123456	maxim@mail.com                                                                                                                  
   10	Irina Sidorova                                                                                                                  	7777777777                                                                                                                                                                                                                                                      	79901234567	irina@mail.com                                                                                                                  
   11	Elena Ivanova                                                                                                                   	8888888888                                                                                                                                                                                                                                                      	70012345678	elena@mail.com                                                                                                                  
   12	Nikita Petrov                                                                                                                   	9999999999                                                                                                                                                                                                                                                      	70123456789	nikita@mail.com                                                                                                                 
   13	Vladimir Sidorov                                                                                                                	0000000001                                                                                                                                                                                                                                                      	70234567890	vladimir@mail.com                                                                                                               
   14	Alexey Ivanov                                                                                                                   	0000000002                                                                                                                                                                                                                                                      	70345678901	alexey@mail.com                                                                                                                 
   15	Svetlana Petrova                                                                                                                	0000000003                                                                                                                                                                                                                                                      	70456789012	svetlana@mail.com                                                                                                               
   16	Ekaterina Sidorova                                                                                                              	0000000004                                                                                                                                                                                                                                                      	70567890123	ekaterina@mail.com                                                                                                              
    \.


      �   �   8	2022-01-01 00:00:00	10:00:00	12:00:00	scheduled                                                                                                                       	1	1	1
 �   9	2022-01-02 00:00:00	12:00:00	14:00:00	scheduled                                                                                                                       	2	2	2
 �   10	2022-01-03 00:00:00	14:00:00	16:00:00	scheduled                                                                                                                       	3	3	3
 �   11	2022-01-04 00:00:00	16:00:00	18:00:00	scheduled                                                                                                                       	4	4	4
 �   12	2022-01-05 00:00:00	18:00:00	20:00:00	scheduled                                                                                                                       	5	5	5
 �   13	2022-01-06 00:00:00	20:00:00	22:00:00	scheduled                                                                                                                       	6	6	6
 �   14	2022-01-07 00:00:00	22:00:00	23:00:00	scheduled                                                                                                                       	7	7	7
 �   15	2022-01-08 00:00:00	00:00:00	02:00:00	scheduled                                                                                                                       	8	8	1
 �   16	2022-01-09 00:00:00	02:00:00	04:00:00	scheduled                                                                                                                       	9	9	2
 �   17	2022-01-10 00:00:00	04:00:00	06:00:00	scheduled                                                                                                                       	10	10	3
 �   18	2022-01-11 00:00:00	06:00:00	08:00:00	scheduled                                                                                                                       	11	11	4
 �   19	2022-01-12 00:00:00	08:00:00	10:00:00	scheduled                                                                                                                       	12	12	5
 �   20	2022-01-13 00:00:00	10:00:00	12:00:00	scheduled                                                                                                                       	13	13	6
 �   21	2022-01-14 00:00:00	12:00:00	14:00:00	scheduled                                                                                                                       	14	14	7
 �   22	2022-01-15 00:00:00	14:00:00	16:00:00	scheduled                                                                                                                       	15	15	1
 �   23	2022-01-16 00:00:00	16:00:00	18:00:00	scheduled                                                                                                                       	16	16	2
 �   24	2022-01-17 00:00:00	18:00:00	20:00:00	scheduled                                                                                                                       	17	1	3
 �   25	2022-01-18 00:00:00	20:00:00	22:00:00	scheduled                                                                                                                       	1	2	4
    \.


           1	Mikulina Alice Romanovna                                                                                                        	6117 002651, given in Ryazan oblast                                                                                                                                                                                                                             	89036417779	alisa.mikulina@yandex.ru                                                                                                        
   2	Pankova Christina Sergeevna                                                                                                     	1234 567890, given in Moscow oblast                                                                                                                                                                                                                             	89772852541	punkris@yandex.ru                                                                                                               
    \.


      �   L   1	{Monday,Wednesday,Friday}	urban	08:00:00	01:30:00	City Center	Suburbia	30
 H   2	{Tuesday,Thursday}	suburban	09:30:00	02:00:00	Suburbia	City Center	40
 Q   3	{Monday,Wednesday,Friday,Sunday}	intercity	13:00:00	03:30:00	City A	City B	200
 L   4	{Tuesday,Thursday,Saturday}	intercity	10:00:00	04:00:00	City B	City C	250
 V   5	{Monday,Wednesday,Friday,Sunday}	international	06:00:00	10:00:00	City A	City D	1000
 Q   6	{Tuesday,Thursday,Saturday}	international	12:00:00	12:00:00	City C	City D	1500
 D   7	{Monday}	urban	07:30:00	00:45:00	City Center	Business District	10
    \.


      �      1	1	yes	23
 
   2	2	no	23
    3	3	yes	23
 
   4	4	no	23
    5	5	yes	23
 
   6	6	no	23
    7	7	yes	23
 
   8	8	no	23
    9	9	yes	23
    10	10	no	23
    11	11	yes	23
    12	12	no	23
    \.


      �   2   1	09:30:00	11:30:00	no 	online 	23	1	3	16	400	1	1
 2   2	09:30:00	11:30:00	no 	online 	23	1	3	16	400	3	3
 2   3	09:30:00	11:30:00	no 	offline	23	1	3	16	400	5	5
 2   4	09:30:00	11:30:00	no 	online 	23	1	3	16	400	7	7
 2   5	09:30:00	11:30:00	no 	offline	23	1	3	16	400	9	9
 4   6	09:30:00	11:30:00	no 	online 	23	1	3	16	400	11	11
    \.


      �   !   1	1	1	08:12:00	08:10:00	00:02:00
 !   3	5	6	14:40:00	14:20:00	00:20:00
    \.


     