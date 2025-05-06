CLASS zcl_local_class_nmt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_local_class_nmt IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

*    SELECT FROM /dmo/customer
*         FIELDS customer_id,
*                title,
*                CASE title
*                  WHEN 'Mr.'  THEN 'Mister'
*                  WHEN 'Mrs.' THEN 'Misses'
*                  ELSE             ' '
*               END AS title_long
*
*        WHERE country_code = 'AT'
*         INTO TABLE @DATA(result_simple).
*
*    out->write(
*      EXPORTING
*        data   = result_simple
*        name   = 'RESULT_SIMPLE'
*    ).
*
**********************************************************************
*
*    SELECT FROM /DMO/flight
*         FIELDS flight_date,
*                seats_max,
*                seats_occupied,
*                CASE
*                  WHEN seats_occupied < seats_max THEN 'Seats Avaliable'
*                  WHEN seats_occupied = seats_max THEN 'Fully Booked'
*                  WHEN seats_occupied > seats_max THEN 'Overbooked!'
*                  ELSE                                 'This is impossible'
*                END AS Booking_State
*
*          WHERE carrier_id    = 'LH'
*            AND connection_id = '0400'
*           INTO TABLE @DATA(result_complex).
*
*    out->write(
*      EXPORTING
*        data   = result_complex
*        name   = 'RESULT_COMPLEX'
*    ).

*    SELECT FROM /dmo/flight
*         FIELDS seats_max,
*                seats_occupied,
*
*                seats_max - seats_occupied           AS seats_avaliable,
*
*                (   CAST( seats_occupied AS FLTP )
*                  * CAST( 100 AS FLTP )
*                ) / CAST(  seats_max AS FLTP )       AS percentage_fltp
*
*           WHERE carrier_id = 'LH' AND connection_id = '0400'
*            INTO TABLE @DATA(result).
*
*    out->write(
*      EXPORTING
*        data   = result
*        name   = 'RESULT'
*    ).


    SELECT FROM /dmo/customer
         FIELDS customer_id,

                street && ',' && ' ' && postal_code && ' ' && city   AS address_expr,

                concat( street,
                        concat_with_space(  ',',
                                             concat_with_space( postal_code,
                                                                upper(  city ),
                                                                1
                                                              ),
                                            1
                                         )
                     ) AS address_func

          WHERE country_code = 'ES'
           INTO TABLE @DATA(result_concat).

    out->write(
      EXPORTING
        data   = result_concat
        name   = 'RESULT_CONCAT'
    ).

**********************************************************************

    SELECT FROM /dmo/carrier
         FIELDS carrier_id,
                name,
                upper( name )   AS name_upper,
                lower( name )   AS name_lower,
                initcap( name ) AS name_initcap

         WHERE carrier_id = 'SR'
          INTO TABLE @DATA(result_transform).

    out->write(
      EXPORTING
        data   = result_transform
        name   = 'RESULT_TRANSLATE'
    ).

**********************************************************************

   SELECT FROM /dmo/flight
       FIELDS flight_date,
              cast( flight_date as char( 8 ) )  AS flight_date_raw,

              left( flight_Date, 4   )          AS year,

              right(  flight_date, 2 )          AS day,

              substring(  flight_date, 5, 2 )   AS month

        WHERE carrier_id = 'LH'
          AND connection_id = '0400'
         INTO TABLE @DATA(result_substring).

    out->write(
      EXPORTING
        data   = result_substring
        name   = 'RESULT_SUBSTRING'
    ).


  ENDMETHOD.
ENDCLASS.
