CLASS ZCL_ASS_MUSTACHE_OS_W3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.

    TYPES: BEGIN OF gty_destinations_s,
             carrier type string,
             connid type string,
             city TYPE string,
             country  TYPE string,
           END OF gty_destinations_s.

    TYPES: gty_destinations_tt TYPE TABLE OF gty_destinations_s with empty key.

    TYPES: BEGIN OF gty_flightplan_s,
             ptitle  TYPE string,
             title  TYPE string,
             dest TYPE gty_destinations_tt,
           END OF gty_flightplan_s.

    types: gty_flightplan_tt type table of gty_flightplan_s with empty key.

    CLASS-METHODS:
      get_fplan_data RETURNING VALUE(rv_fplan_data) TYPE gty_flightplan_s,
      get_fplan_html IMPORTING is_fplan_data  TYPE gty_flightplan_s
                     EXPORTING ev_error       TYPE string
                               ev_html_string TYPE string.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ASS_MUSTACHE_OS_W3 IMPLEMENTATION.


  METHOD get_fplan_data.
  SELECT * FROM SPFLI into table @data(lt_spfli).



    rv_fplan_data = VALUE gty_flightplan_s(
        ptitle = 'My own Flightplan'
        title = 'Check out the next destinations of my flights '

        dest = VALUE gty_destinations_tt( FOR ls_spfli in lt_spfli ( city = ls_spfli-cityto   country = ls_spfli-countryto  carrier = ls_spfli-carrid connid = ls_spfli-connid )
        )
    ).
  ENDMETHOD.


  METHOD get_fplan_html.

    CONSTANTS: lc_nl TYPE c VALUE cl_abap_char_utilities=>newline.

    TRY.
        DATA(lo_mustcahe) = NEW zcl_mustache(
          |<!DOCTYPE html>|                                 && lc_nl &&
          |<html> |                                          && lc_nl &&
          |  <head> |                                        && lc_nl &&
          |    <title>\{\{ptitle\}\}</title> |                    && lc_nl &&
          |  </head>|                                       && lc_nl &&
          |  <body>|                                        && lc_nl &&
          |    <h1>\{\{title\}\}</h1> |                          && lc_nl &&
          |    <table> |                                       && lc_nl &&
          |      \{\{#dest\}\}|                               && lc_nl &&
          |    <tr> |                                       && lc_nl &&
          |      <td>\{\{carrier\}\} \{\{connid\}\} |     && lc_nl &&
          |      \{\{city\}\} \{\{country\}\}</td> |     && lc_nl &&
          |      <tr>|                               && lc_nl &&
          |      \{\{/dest\}\} |                               && lc_nl &&
          |    </table>|                                       && lc_nl &&
          |  </body>|                                       && lc_nl &&
          |</html>| ).

        ev_html_string = lo_mustcahe->render( is_fplan_data ).
      CATCH zcx_mustache_error INTO DATA(lo_exception).
        ev_error = lo_exception->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    "Get flightplan to display on HTML Board
    get_fplan_html( EXPORTING is_fplan_data  = get_fplan_data( )
                        IMPORTING ev_error       = DATA(lv_error)
                                  ev_html_string = DATA(lv_html_string) ).
    IF lv_error IS NOT INITIAL.
      out->write( lv_error ).
    ELSE.
      out->write( lv_html_string ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
