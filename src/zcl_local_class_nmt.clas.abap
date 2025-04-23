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
    DATA connection  TYPE REF TO lcl_connection.

    try.
         connection = NEW #(
                         i_carrier_id    = 'LH'
                         i_connection_id = '0400'
                       ).
       CATCH cx_abap_invalid_value.
          out->write( `Method call failed` ).
     endtry.

     out->write( connection->get_output( ) ).
  ENDMETHOD.
ENDCLASS.
