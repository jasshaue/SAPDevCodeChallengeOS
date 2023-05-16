CLASS zass_cl_very_simple_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA: output TYPE REF TO if_oo_adt_classrun_out.

    INTERFACES if_oo_adt_classrun .


  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS do_sth .
ENDCLASS.



CLASS zass_cl_very_simple_class IMPLEMENTATION.


  METHOD do_sth.

    output->write( 'Say "Hello World" ' ).

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    out->write( 'Main started' ).
    output = out.
    do_sth( ).
    out->write(  'Main ended' ).
  ENDMETHOD.
ENDCLASS.
