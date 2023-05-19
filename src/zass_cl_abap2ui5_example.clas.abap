class ZASS_CL_ABAP2UI5_EXAMPLE definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZASS_CL_ABAP2UI5_EXAMPLE IMPLEMENTATION.


  method IF_HTTP_EXTENSION~HANDLE_REQUEST.
       DATA lt_header TYPE tihttpnvp.
   server->request->get_header_fields( CHANGING fields = lt_header ).

   DATA lt_param TYPE tihttpnvp.
   server->request->get_form_fields( CHANGING fields = lt_param ).

   z2ui5_cl_http_handler=>client = VALUE #(
      t_header = lt_header
      t_param  = lt_param
      body     = server->request->get_cdata( ) ).

      DATA(lt_config) = VALUE z2ui5_if_client=>ty_t_name_value(
      (  name = `data-sap-ui-theme`         value = `sap_belize` ) "<- adjusted
      (  name = `src`                       value = `https://sdk.openui5.org/resources/sap-ui-core.js` )
      (  name = `data-sap-ui-libs`          value = `sap.m` )
      (  name = `data-sap-ui-bindingSyntax` value = `complex` )
      (  name = `data-sap-ui-frameOptions`  value = `trusted` )
      (  name = `data-sap-ui-compatVersion` value = `edge` ) ).

   DATA(lv_resp) = SWITCH #( server->request->get_method( )
      WHEN 'GET'  THEN z2ui5_cl_http_handler=>http_get( t_config = lt_config title = 'My OS Abap ABAP2UI5 App' check_logging = abap_true )
      WHEN 'POST' THEN z2ui5_cl_http_handler=>http_post( ) ).

   server->response->set_cdata( lv_resp ).
   server->response->set_status( code = 200 reason = 'success' ).

  endmethod.
ENDCLASS.
