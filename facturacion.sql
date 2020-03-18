WITH each_it_item as (SELECT 
        p.bp,
        d.name as depot_name,
        CASE WHEN d.name='BASE AEROPUERTO' OR d.name='BASE ATO_BASE' OR d.name='BASE_CAE' OR d.name='CORPORATIVO' OR d.name='PARQUE LAN' THEN 'ATO/Corp.'
            WHEN d.name='BASE CARGA' THEN 'ATO/Corp.' --THEN 'Carga'
            WHEN d.name='BASE ESTADO 10' THEN 'Estado 10'
            WHEN d.name='EDIFICIO HUIDOBRO' THEN 'Huidobro'
            WHEN d.name='BASE MANTTO' OR d.name='Trip_Mantto' THEN 'Base Mantto'
            WHEN d.name='EDIFICIO HUIDOBRO TRIPULACION' OR d.name='EDIFICIO HUIDOBRO TRIPULACION_Activ' OR d.name='Trip_Aeropuerto' OR d.name='Trip_Aeropuerto_Activ' 
                OR d.name='Trip_Cae' OR d.name='Trip_Cae_Activ' OR d.name='Trip_Club Lo Aguirre_Activ' OR d.name='Trip_Corporativo' OR d.name='Trip_Corporativo_Activ'
                OR d.name='TRIP_LSG_SKYCHEF' OR d.name='Trip_Mantto_Activ' OR d.name='Trip_Parque Lan' OR d.name='Trip_Parque Lan_Activ' THEN 'Tripulacion'
            ELSE 'Falta Informacion'
        END AS base_dicc_fact,
        CASE WHEN d.name='BASE AEROPUERTO' OR d.name='BASE ATO_BASE' OR d.name='Trip_Aeropuerto' OR d.name='Trip_Aeropuerto_Activ' THEN 'ATO/Corp.'
            WHEN d.name='CORPORATIVO' OR d.name='Trip_Corporativo' OR d.name='Trip_Corporativo_Activ' THEN 'ATO/Corp.'
            WHEN d.name='BASE_CAE' OR d.name='Trip_Cae' OR d.name='Trip_Cae_Activ' THEN 'ATO/Corp.'
            WHEN d.name='BASE CARGA' OR d.name='Trip_Club Lo Aguirre_Activ' OR d.name='TRIP_LSG_SKYCHEF' THEN 'ATO/Corp.' --THEN 'Carga'
            WHEN d.name='PARQUE LAN' OR d.name='Trip_Parque Lan' OR d.name='Trip_Parque Lan_Activ' THEN 'ATO/corp.'
            WHEN d.name='BASE ESTADO 10' THEN 'Estado 10'
            WHEN d.name='EDIFICIO HUIDOBRO' OR d.name='EDIFICIO HUIDOBRO TRIPULACION' OR d.name='EDIFICIO HUIDOBRO TRIPULACION_Activ' THEN 'Huidobro'
            WHEN d.name='BASE MANTTO' OR d.name='Trip_Mantto' OR d.name='Trip_Mantto_Activ' THEN 'Base Mantto'
            ELSE 'Falta Informacion'
        END AS base_facturacion,
        ii.itinerary_route_id,
        ii.action,
        CASE WHEN ii.billing_code = 'CIUDAD SATÉLITE' THEN 'CIUDAD SATELITE'
            WHEN ii.billing_code = 'CONCHALÍ' THEN 'CONCHALI'
            WHEN ii.billing_code = 'ESTACIÓN CENTRAL' OR ii.billing_code = 'ESTACION  CENTRAL' THEN 'ESTACION CENTRAL'
            WHEN ii.billing_code = 'INDEPENDENCIA.' THEN 'INDEPENDENCIA'
            WHEN ii.billing_code = 'MAIPÚ' THEN 'MAIPU'
            WHEN ii.billing_code = 'PEÑALOLÉN' THEN 'PEÑALOLEN'
            WHEN ii.billing_code = 'PUDAHUEL SUR' THEN 'PUDAHUEL'
            WHEN ii.billing_code = 'SAN JOAQUÍN' THEN 'SAN JOAQUIN'
            WHEN ii.billing_code = 'SAN JOSÉ DE MAIPO' THEN 'SAN JOSE DE MAIPO'
            WHEN ii.billing_code = 'SAN RAMÓN' THEN 'SAN RAMON'
            WHEN ii.billing_code = 'SANTIAGO CENTRO' THEN 'SANTIAGO'
            WHEN ii.billing_code = 'QUILPUÉ' OR ii.billing_code = 'QUILPUE' OR ii.billing_code = 'VILLA ALEMANA' THEN 'VIAJE QUINTA REGION'
            ELSE ii.billing_code
        END as billing_code,
        ((it.shift_at AT TIME ZONE 'UTC')AT TIME ZONE 'America/Santiago')::timestamp without time zone as shift_at,
        ((ii.departs_at AT TIME ZONE 'UTC')AT TIME ZONE 'America/Santiago')::timestamp without time zone as salida_planificada,
        CASE WHEN d.name='EDIFICIO HUIDOBRO TRIPULACION' OR d.name='EDIFICIO HUIDOBRO TRIPULACION_Activ' OR d.name='Trip_Aeropuerto' OR d.name='Trip_Aeropuerto_Activ' 
                OR d.name='Trip_Cae' OR d.name='Trip_Cae_Activ' OR d.name='Trip_Club Lo Aguirre_Activ' OR d.name='Trip_Corporativo' OR d.name='Trip_Corporativo_Activ'
                OR d.name='TRIP_LSG_SKYCHEF' OR d.name='Trip_Mantto_Activ' OR d.name='Trip_Parque Lan' OR d.name='Trip_Parque Lan_Activ' THEN 'Tripulacion'
            ELSE 'Tierra'
        END as mundo,
        CASE WHEN ii.addr_city = 'CALERA DE TANDO' THEN 'CALERA DE TANGO'
            WHEN ii.addr_city = 'CIUDAD SATÉLITE' OR ii.addr_city='MAIPU CIUDAD SATELITE' THEN 'CIUDAD SATELITE'
            WHEN ii.addr_city = 'CONCHALÍ' THEN 'CONCHALI'
            WHEN ii.addr_city = 'ESTACIÓN CENTRAL' OR ii.addr_city = 'ESTACION  CENTRAL' THEN 'ESTACION CENTRAL'
            WHEN ii.addr_city = 'INDEPENDENCIA.' OR ii.addr_city = 'INDEPENCIA' THEN 'INDEPENDENCIA'
            WHEN ii.addr_city = 'LA FLORIIDA' THEN 'LA FLORIDA'
            WHEN ii.addr_city = 'LAS CNDES' OR ii.addr_city = 'LAS CONDESA' OR ii.addr_city = 'LAS CONDESO' OR ii.addr_city = 'LAS CONDS' THEN 'LAS CONDES'
            WHEN ii.addr_city = 'MAIPÚ' THEN 'MAIPU'
            WHEN ii.addr_city = 'MIRASUR SAN BERNARDO' THEN 'SAN BERNARDO'
            WHEN ii.addr_city = 'NUÑOA' OR ii.addr_city = 'ÑUÑOZ' THEN 'ÑUÑOA'
            WHEN ii.addr_city = 'PEÑALOLÉN' THEN 'PEÑALOLEN'
            WHEN ii.addr_city = 'PROVIDECIA' THEN 'PROVIDENCIA'
            WHEN ii.addr_city = 'PUDAHUEL SUR' OR ii.addr_city = 'PUDAHUELA' THEN 'PUDAHUEL'
            WHEN ii.addr_city = 'QUIILICURA' OR ii.addr_city = 'QULICURA' THEN 'QUILICURA'
            WHEN ii.addr_city = 'QUINTA NORMAL' OR ii.addr_city = 'QUNITA NORMAL' THEN 'QUINTA NORMAL'
            WHEN ii.addr_city = 'SAN JOSÉ DE MAIPO' THEN 'SAN JOSE DE MAIPO'
            WHEN ii.addr_city = 'SAN JOAQUÍN' THEN 'SAN JOAQUIN'
            WHEN ii.addr_city = 'SAN MIGEUL' THEN 'SAN MIGUEL'
            WHEN ii.addr_city = 'SAN RAMÓN' THEN 'SAN RAMON'
            WHEN ii.addr_city = 'SANTIACO' OR ii.addr_city = 'SANTIAGO CENTRO' OR ii.addr_city = 'SANTIEGO' OR ii.addr_city = 'VISANTIAGO' THEN 'SANTIAGO'
            WHEN ii.addr_city = 'VITACURABA' OR ii.addr_city = 'VITACURAL' THEN 'VITACURA'
            ELSE ii.addr_city
        END as comuna,
        CASE WHEN POSITION('Delfos_A' IN tp.name) > 0 THEN 'Delfos_A'
            WHEN POSITION('Delfos_B' IN tp.name) > 0 THEN 'Delfos_B'
            WHEN POSITION('Delfos_M' IN tp.name) > 0 THEN 'Delfos_M'
            WHEN POSITION('Redvan' IN tp.name) > 0 THEN 'Redvan'
            ELSE tp.name
        END as proveedor,
        CASE WHEN POSITION('Delfos_A' IN tp.name) > 0 THEN 'Delfos'
            WHEN POSITION('Delfos_B' IN tp.name) > 0 THEN 'Delfos'
            WHEN POSITION('Delfos_M' IN tp.name) > 0 THEN 'Delfos'
            WHEN POSITION('Redvan' IN tp.name) > 0 THEN 'Redvan'
            ELSE tp.name
        END as proveedor_agrupado,
        COUNT(*) OVER (PARTITION BY ii.itinerary_route_id) as ocupacion

FROM public.o_lan_itineraries AS it     
    LEFT JOIN public.o_lan_itinerary_routes as ir ON it.id = ir.itinerary_id
    LEFT JOIN public.o_lan_itinerary_items as ii on ir.id = ii.itinerary_route_id
    LEFT JOIN public.o_lan_frozen_profiles as p on ii.frozen_profile_id = p.id
    LEFT JOIN public.o_lan_frozen_depots as d on it.frozen_depot_id = d.id
    LEFT JOIN public.transportation_providers tp on (tp.organization_id = it.organization_id and ir.transportation_provider_id = tp.id)

WHERE   date(((it.shift_at AT TIME ZONE 'UTC')AT TIME ZONE 'America/Santiago')::timestamp without time zone) BETWEEN(current_date - interval '3 months')::date AND ((current_timestamp AT TIME ZONE 'America/Santiago')::timestamp without time zone)::date 
        AND (it.status = 'APPROVED_FOR_BILLING') -- or it.status = 'APPROVED_FOR_TRANSPORTATION')
        AND ii.disabled_at is NULL
        AND it.organization_id = 4
        AND ii.item_type != 'DEPOT'
        AND p.organization_id = 4
        AND d.nid != 'ANDES'
        AND tp.name != 'Alas' AND tp.name != 'Transtur' AND tp.name != 'Transvip' AND tp.name != 'Transcordero (NO UTILIZAR, proveedor desvinculado)'
        AND tp.name != 'Aerospeed' AND tp.name != 'RTX SCL'
GROUP BY p.bp, it.shift_at, d.name, ii.itinerary_route_id, ii.action, ii.billing_code, ii.addr_city, tp.name, ii.departs_at, depot_name
),

each_ii_times as
(
SELECT
        bp,
        depot_name,
        base_dicc_fact,
        base_facturacion,
        itinerary_route_id,
        mundo,
        action,
        shift_at,
        CASE WHEN billing_code is NULL THEN comuna
            ELSE billing_code
        END as codigo_facturacion,
        proveedor,        
        proveedor_agrupado,
        ocupacion, 
        salida_planificada
FROM each_it_item
)

SELECT *,
        array_length((SELECT array_agg(distinct addr_city)
        from public.o_lan_itinerary_items ii_aux
        where ii_aux.itinerary_route_id = ii.itinerary_route_id
        AND ii_aux.disabled_at is null
        AND CASE WHEN ii.action = 'P' THEN ii_aux.departs_at >= salida_planificada ELSE ii_aux.departs_at <= salida_planificada END AND addr_city IS NOT null AND item_type = 'STOP'),1)-1 as nr_cities
        
FROM each_ii_times ii