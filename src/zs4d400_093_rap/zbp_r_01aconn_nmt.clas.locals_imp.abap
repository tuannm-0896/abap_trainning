CLASS LHC_ZR_01ACONN_NMT DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Flight_NMT
        RESULT result,
      validateCarrid FOR VALIDATE ON SAVE
            IMPORTING keys FOR Flight_NMT~validateCarrid.
ENDCLASS.

CLASS LHC_ZR_01ACONN_NMT IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD validateCarrid.
    DATA failed_record   LIKE LINE OF failed-Flight_NMT.
    DATA reported_record LIKE LINE OF reported-Flight_NMT.

    READ ENTITIES OF ZR_01ACONN_NMT IN LOCAL MODE
      ENTITY Flight_NMT
      FIELDS ( carrid )
        WITH CORRESPONDING #(  keys )
      RESULT DATA(flights).

    LOOP AT flights INTO DATA(flight).
      IF flight-carrid = 'MT'.

        failed_record-%tky = flight-%tky.
        APPEND failed_record TO failed-Flight_NMT.

        reported_record-%tky = flight-%tky.
        reported_record-%msg =
          new_message(
                id       = 'ZMSG_01ACONN_NMT'
                number   = '102'
                severity = if_abap_behv_message=>severity-error
          ).

        APPEND reported_record TO reported-Flight_NMT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
