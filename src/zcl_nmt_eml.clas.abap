CLASS zcl_nmt_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_nmt_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
      out->write( `Starting execution...` ).  " Thêm log để kiểm tra

      DATA agencies_upd TYPE TABLE FOR CREATE ZR_01ACONN_NMT.
      out->write( `agencies_upd prepared` ).  " Thêm log

      agencies_upd = VALUE #( ( %cid = 'CONN_001' carrid = 'LH' Connid = '12' AirportFrom = 'JFK' AirportTo = 'FRA' ) ).
      out->write( `Data assigned to agencies_upd` ).  " Thêm log

      MODIFY ENTITIES OF ZR_01ACONN_NMT
        ENTITY Flight_NMT
        CREATE
          FIELDS ( carrid connid airportfrom airportto )
          WITH agencies_upd
        MAPPED DATA(mapped)
        FAILED DATA(failed)
        REPORTED DATA(reported).

      out->write( `MODIFY ENTITIES executed` ).  " Thêm log

      COMMIT ENTITIES.

      out->write( `Method execution finished!` ).
  ENDMETHOD.
ENDCLASS.
