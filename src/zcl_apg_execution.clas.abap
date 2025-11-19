class ZCL_APG_EXECUTION definition
  public
  final
  create public .

public section.

  class-methods EXECUTE_GATE
    importing
      !I_POINT_ID type ZAPG_POINT_ID
      !I_CONTEXT type ref to ZIF_APG_CONTEXT
    changing
      !CO_MESSAGE_CONTAINER type BAPIRET2_T
    raising
      ZCX_APG_ERROR .
ENDCLASS.



CLASS ZCL_APG_EXECUTION IMPLEMENTATION.


  METHOD execute_gate.

    DATA(lt_handlers) = zcl_apg_factory=>get_handlers_for_gate( i_point_id ).

    LOOP AT lt_handlers INTO DATA(lo_handler).

      lo_handler->execute( EXPORTING i_context            = i_context
                           CHANGING  co_message_container = co_message_container ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
