class ZCL_APG_EXECUTION definition
  public
  final
  create public .

public section.

  TYPES TT_BAPIRET2 TYPE STANDARD TABLE OF BAPIRET2 WITH EMPTY KEY.

  class-methods EXECUTE_GATE
    importing
      !I_POINT_ID type ZAPG_POINT_ID
      !I_CONTEXT type ref to ZIF_APG_CONTEXT
    changing
      !CO_MESSAGE_CONTAINER type TT_BAPIRET2
    raising
      ZCX_APG_ERROR .
ENDCLASS.



CLASS ZCL_APG_EXECUTION IMPLEMENTATION.


  METHOD execute_gate.

    DATA(lt_handlers) = zcl_apg_factory=>get_active_handlers_for_gate( i_point_id = i_point_id
                                                                       i_context  = i_context ).

    LOOP AT lt_handlers INTO DATA(lo_handler).

      lo_handler->execute( EXPORTING i_context            = i_context
                           CHANGING  co_message_container = co_message_container ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
