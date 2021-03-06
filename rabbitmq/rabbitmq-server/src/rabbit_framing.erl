-module(rabbit_framing).
-include("rabbit_framing.hrl").

-export([lookup_method_name/1]).

-export([method_id/1]).
-export([method_has_content/1]).
-export([method_fieldnames/1]).
-export([decode_method_fields/2]).
-export([decode_properties/2]).
-export([encode_method_fields/1]).
-export([encode_properties/1]).
-export([lookup_amqp_exception/1]).

bitvalue(true) -> 1;
bitvalue(false) -> 0;
bitvalue(undefined) -> 0.

lookup_method_name({10, 10}) -> 'connection.start';
lookup_method_name({10, 11}) -> 'connection.start_ok';
lookup_method_name({10, 20}) -> 'connection.secure';
lookup_method_name({10, 21}) -> 'connection.secure_ok';
lookup_method_name({10, 30}) -> 'connection.tune';
lookup_method_name({10, 31}) -> 'connection.tune_ok';
lookup_method_name({10, 40}) -> 'connection.open';
lookup_method_name({10, 41}) -> 'connection.open_ok';
lookup_method_name({10, 50}) -> 'connection.redirect';
lookup_method_name({10, 60}) -> 'connection.close';
lookup_method_name({10, 61}) -> 'connection.close_ok';
lookup_method_name({20, 10}) -> 'channel.open';
lookup_method_name({20, 11}) -> 'channel.open_ok';
lookup_method_name({20, 20}) -> 'channel.flow';
lookup_method_name({20, 21}) -> 'channel.flow_ok';
lookup_method_name({20, 30}) -> 'channel.alert';
lookup_method_name({20, 40}) -> 'channel.close';
lookup_method_name({20, 41}) -> 'channel.close_ok';
lookup_method_name({30, 10}) -> 'access.request';
lookup_method_name({30, 11}) -> 'access.request_ok';
lookup_method_name({40, 10}) -> 'exchange.declare';
lookup_method_name({40, 11}) -> 'exchange.declare_ok';
lookup_method_name({40, 20}) -> 'exchange.delete';
lookup_method_name({40, 21}) -> 'exchange.delete_ok';
lookup_method_name({50, 10}) -> 'queue.declare';
lookup_method_name({50, 11}) -> 'queue.declare_ok';
lookup_method_name({50, 20}) -> 'queue.bind';
lookup_method_name({50, 21}) -> 'queue.bind_ok';
lookup_method_name({50, 30}) -> 'queue.purge';
lookup_method_name({50, 31}) -> 'queue.purge_ok';
lookup_method_name({50, 40}) -> 'queue.delete';
lookup_method_name({50, 41}) -> 'queue.delete_ok';
lookup_method_name({50, 50}) -> 'queue.unbind';
lookup_method_name({50, 51}) -> 'queue.unbind_ok';
lookup_method_name({60, 10}) -> 'basic.qos';
lookup_method_name({60, 11}) -> 'basic.qos_ok';
lookup_method_name({60, 20}) -> 'basic.consume';
lookup_method_name({60, 21}) -> 'basic.consume_ok';
lookup_method_name({60, 30}) -> 'basic.cancel';
lookup_method_name({60, 31}) -> 'basic.cancel_ok';
lookup_method_name({60, 40}) -> 'basic.publish';
lookup_method_name({60, 50}) -> 'basic.return';
lookup_method_name({60, 60}) -> 'basic.deliver';
lookup_method_name({60, 70}) -> 'basic.get';
lookup_method_name({60, 71}) -> 'basic.get_ok';
lookup_method_name({60, 72}) -> 'basic.get_empty';
lookup_method_name({60, 80}) -> 'basic.ack';
lookup_method_name({60, 90}) -> 'basic.reject';
lookup_method_name({60, 100}) -> 'basic.recover';
lookup_method_name({70, 10}) -> 'file.qos';
lookup_method_name({70, 11}) -> 'file.qos_ok';
lookup_method_name({70, 20}) -> 'file.consume';
lookup_method_name({70, 21}) -> 'file.consume_ok';
lookup_method_name({70, 30}) -> 'file.cancel';
lookup_method_name({70, 31}) -> 'file.cancel_ok';
lookup_method_name({70, 40}) -> 'file.open';
lookup_method_name({70, 41}) -> 'file.open_ok';
lookup_method_name({70, 50}) -> 'file.stage';
lookup_method_name({70, 60}) -> 'file.publish';
lookup_method_name({70, 70}) -> 'file.return';
lookup_method_name({70, 80}) -> 'file.deliver';
lookup_method_name({70, 90}) -> 'file.ack';
lookup_method_name({70, 100}) -> 'file.reject';
lookup_method_name({80, 10}) -> 'stream.qos';
lookup_method_name({80, 11}) -> 'stream.qos_ok';
lookup_method_name({80, 20}) -> 'stream.consume';
lookup_method_name({80, 21}) -> 'stream.consume_ok';
lookup_method_name({80, 30}) -> 'stream.cancel';
lookup_method_name({80, 31}) -> 'stream.cancel_ok';
lookup_method_name({80, 40}) -> 'stream.publish';
lookup_method_name({80, 50}) -> 'stream.return';
lookup_method_name({80, 60}) -> 'stream.deliver';
lookup_method_name({90, 10}) -> 'tx.select';
lookup_method_name({90, 11}) -> 'tx.select_ok';
lookup_method_name({90, 20}) -> 'tx.commit';
lookup_method_name({90, 21}) -> 'tx.commit_ok';
lookup_method_name({90, 30}) -> 'tx.rollback';
lookup_method_name({90, 31}) -> 'tx.rollback_ok';
lookup_method_name({100, 10}) -> 'dtx.select';
lookup_method_name({100, 11}) -> 'dtx.select_ok';
lookup_method_name({100, 20}) -> 'dtx.start';
lookup_method_name({100, 21}) -> 'dtx.start_ok';
lookup_method_name({110, 10}) -> 'tunnel.request';
lookup_method_name({120, 10}) -> 'test.integer';
lookup_method_name({120, 11}) -> 'test.integer_ok';
lookup_method_name({120, 20}) -> 'test.string';
lookup_method_name({120, 21}) -> 'test.string_ok';
lookup_method_name({120, 30}) -> 'test.table';
lookup_method_name({120, 31}) -> 'test.table_ok';
lookup_method_name({120, 40}) -> 'test.content';
lookup_method_name({120, 41}) -> 'test.content_ok';
lookup_method_name({_ClassId, _MethodId} = Id) -> exit({unknown_method_id, Id}).
method_id('connection.start') -> {10, 10};
method_id('connection.start_ok') -> {10, 11};
method_id('connection.secure') -> {10, 20};
method_id('connection.secure_ok') -> {10, 21};
method_id('connection.tune') -> {10, 30};
method_id('connection.tune_ok') -> {10, 31};
method_id('connection.open') -> {10, 40};
method_id('connection.open_ok') -> {10, 41};
method_id('connection.redirect') -> {10, 50};
method_id('connection.close') -> {10, 60};
method_id('connection.close_ok') -> {10, 61};
method_id('channel.open') -> {20, 10};
method_id('channel.open_ok') -> {20, 11};
method_id('channel.flow') -> {20, 20};
method_id('channel.flow_ok') -> {20, 21};
method_id('channel.alert') -> {20, 30};
method_id('channel.close') -> {20, 40};
method_id('channel.close_ok') -> {20, 41};
method_id('access.request') -> {30, 10};
method_id('access.request_ok') -> {30, 11};
method_id('exchange.declare') -> {40, 10};
method_id('exchange.declare_ok') -> {40, 11};
method_id('exchange.delete') -> {40, 20};
method_id('exchange.delete_ok') -> {40, 21};
method_id('queue.declare') -> {50, 10};
method_id('queue.declare_ok') -> {50, 11};
method_id('queue.bind') -> {50, 20};
method_id('queue.bind_ok') -> {50, 21};
method_id('queue.purge') -> {50, 30};
method_id('queue.purge_ok') -> {50, 31};
method_id('queue.delete') -> {50, 40};
method_id('queue.delete_ok') -> {50, 41};
method_id('queue.unbind') -> {50, 50};
method_id('queue.unbind_ok') -> {50, 51};
method_id('basic.qos') -> {60, 10};
method_id('basic.qos_ok') -> {60, 11};
method_id('basic.consume') -> {60, 20};
method_id('basic.consume_ok') -> {60, 21};
method_id('basic.cancel') -> {60, 30};
method_id('basic.cancel_ok') -> {60, 31};
method_id('basic.publish') -> {60, 40};
method_id('basic.return') -> {60, 50};
method_id('basic.deliver') -> {60, 60};
method_id('basic.get') -> {60, 70};
method_id('basic.get_ok') -> {60, 71};
method_id('basic.get_empty') -> {60, 72};
method_id('basic.ack') -> {60, 80};
method_id('basic.reject') -> {60, 90};
method_id('basic.recover') -> {60, 100};
method_id('file.qos') -> {70, 10};
method_id('file.qos_ok') -> {70, 11};
method_id('file.consume') -> {70, 20};
method_id('file.consume_ok') -> {70, 21};
method_id('file.cancel') -> {70, 30};
method_id('file.cancel_ok') -> {70, 31};
method_id('file.open') -> {70, 40};
method_id('file.open_ok') -> {70, 41};
method_id('file.stage') -> {70, 50};
method_id('file.publish') -> {70, 60};
method_id('file.return') -> {70, 70};
method_id('file.deliver') -> {70, 80};
method_id('file.ack') -> {70, 90};
method_id('file.reject') -> {70, 100};
method_id('stream.qos') -> {80, 10};
method_id('stream.qos_ok') -> {80, 11};
method_id('stream.consume') -> {80, 20};
method_id('stream.consume_ok') -> {80, 21};
method_id('stream.cancel') -> {80, 30};
method_id('stream.cancel_ok') -> {80, 31};
method_id('stream.publish') -> {80, 40};
method_id('stream.return') -> {80, 50};
method_id('stream.deliver') -> {80, 60};
method_id('tx.select') -> {90, 10};
method_id('tx.select_ok') -> {90, 11};
method_id('tx.commit') -> {90, 20};
method_id('tx.commit_ok') -> {90, 21};
method_id('tx.rollback') -> {90, 30};
method_id('tx.rollback_ok') -> {90, 31};
method_id('dtx.select') -> {100, 10};
method_id('dtx.select_ok') -> {100, 11};
method_id('dtx.start') -> {100, 20};
method_id('dtx.start_ok') -> {100, 21};
method_id('tunnel.request') -> {110, 10};
method_id('test.integer') -> {120, 10};
method_id('test.integer_ok') -> {120, 11};
method_id('test.string') -> {120, 20};
method_id('test.string_ok') -> {120, 21};
method_id('test.table') -> {120, 30};
method_id('test.table_ok') -> {120, 31};
method_id('test.content') -> {120, 40};
method_id('test.content_ok') -> {120, 41};
method_id(Name) -> exit({unknown_method_name, Name}).
method_has_content('connection.start') -> false;
method_has_content('connection.start_ok') -> false;
method_has_content('connection.secure') -> false;
method_has_content('connection.secure_ok') -> false;
method_has_content('connection.tune') -> false;
method_has_content('connection.tune_ok') -> false;
method_has_content('connection.open') -> false;
method_has_content('connection.open_ok') -> false;
method_has_content('connection.redirect') -> false;
method_has_content('connection.close') -> false;
method_has_content('connection.close_ok') -> false;
method_has_content('channel.open') -> false;
method_has_content('channel.open_ok') -> false;
method_has_content('channel.flow') -> false;
method_has_content('channel.flow_ok') -> false;
method_has_content('channel.alert') -> false;
method_has_content('channel.close') -> false;
method_has_content('channel.close_ok') -> false;
method_has_content('access.request') -> false;
method_has_content('access.request_ok') -> false;
method_has_content('exchange.declare') -> false;
method_has_content('exchange.declare_ok') -> false;
method_has_content('exchange.delete') -> false;
method_has_content('exchange.delete_ok') -> false;
method_has_content('queue.declare') -> false;
method_has_content('queue.declare_ok') -> false;
method_has_content('queue.bind') -> false;
method_has_content('queue.bind_ok') -> false;
method_has_content('queue.purge') -> false;
method_has_content('queue.purge_ok') -> false;
method_has_content('queue.delete') -> false;
method_has_content('queue.delete_ok') -> false;
method_has_content('queue.unbind') -> false;
method_has_content('queue.unbind_ok') -> false;
method_has_content('basic.qos') -> false;
method_has_content('basic.qos_ok') -> false;
method_has_content('basic.consume') -> false;
method_has_content('basic.consume_ok') -> false;
method_has_content('basic.cancel') -> false;
method_has_content('basic.cancel_ok') -> false;
method_has_content('basic.publish') -> true;
method_has_content('basic.return') -> true;
method_has_content('basic.deliver') -> true;
method_has_content('basic.get') -> false;
method_has_content('basic.get_ok') -> true;
method_has_content('basic.get_empty') -> false;
method_has_content('basic.ack') -> false;
method_has_content('basic.reject') -> false;
method_has_content('basic.recover') -> false;
method_has_content('file.qos') -> false;
method_has_content('file.qos_ok') -> false;
method_has_content('file.consume') -> false;
method_has_content('file.consume_ok') -> false;
method_has_content('file.cancel') -> false;
method_has_content('file.cancel_ok') -> false;
method_has_content('file.open') -> false;
method_has_content('file.open_ok') -> false;
method_has_content('file.stage') -> true;
method_has_content('file.publish') -> false;
method_has_content('file.return') -> true;
method_has_content('file.deliver') -> false;
method_has_content('file.ack') -> false;
method_has_content('file.reject') -> false;
method_has_content('stream.qos') -> false;
method_has_content('stream.qos_ok') -> false;
method_has_content('stream.consume') -> false;
method_has_content('stream.consume_ok') -> false;
method_has_content('stream.cancel') -> false;
method_has_content('stream.cancel_ok') -> false;
method_has_content('stream.publish') -> true;
method_has_content('stream.return') -> true;
method_has_content('stream.deliver') -> true;
method_has_content('tx.select') -> false;
method_has_content('tx.select_ok') -> false;
method_has_content('tx.commit') -> false;
method_has_content('tx.commit_ok') -> false;
method_has_content('tx.rollback') -> false;
method_has_content('tx.rollback_ok') -> false;
method_has_content('dtx.select') -> false;
method_has_content('dtx.select_ok') -> false;
method_has_content('dtx.start') -> false;
method_has_content('dtx.start_ok') -> false;
method_has_content('tunnel.request') -> true;
method_has_content('test.integer') -> false;
method_has_content('test.integer_ok') -> false;
method_has_content('test.string') -> false;
method_has_content('test.string_ok') -> false;
method_has_content('test.table') -> false;
method_has_content('test.table_ok') -> false;
method_has_content('test.content') -> true;
method_has_content('test.content_ok') -> true;
method_has_content(Name) -> exit({unknown_method_name, Name}).
method_fieldnames('connection.start') -> [version_major, version_minor, server_properties, mechanisms, locales];
method_fieldnames('connection.start_ok') -> [client_properties, mechanism, response, locale];
method_fieldnames('connection.secure') -> [challenge];
method_fieldnames('connection.secure_ok') -> [response];
method_fieldnames('connection.tune') -> [channel_max, frame_max, heartbeat];
method_fieldnames('connection.tune_ok') -> [channel_max, frame_max, heartbeat];
method_fieldnames('connection.open') -> [virtual_host, capabilities, insist];
method_fieldnames('connection.open_ok') -> [known_hosts];
method_fieldnames('connection.redirect') -> [host, known_hosts];
method_fieldnames('connection.close') -> [reply_code, reply_text, class_id, method_id];
method_fieldnames('connection.close_ok') -> [];
method_fieldnames('channel.open') -> [out_of_band];
method_fieldnames('channel.open_ok') -> [];
method_fieldnames('channel.flow') -> [active];
method_fieldnames('channel.flow_ok') -> [active];
method_fieldnames('channel.alert') -> [reply_code, reply_text, details];
method_fieldnames('channel.close') -> [reply_code, reply_text, class_id, method_id];
method_fieldnames('channel.close_ok') -> [];
method_fieldnames('access.request') -> [realm, exclusive, passive, active, write, read];
method_fieldnames('access.request_ok') -> [ticket];
method_fieldnames('exchange.declare') -> [ticket, exchange, type, passive, durable, auto_delete, internal, nowait, arguments];
method_fieldnames('exchange.declare_ok') -> [];
method_fieldnames('exchange.delete') -> [ticket, exchange, if_unused, nowait];
method_fieldnames('exchange.delete_ok') -> [];
method_fieldnames('queue.declare') -> [ticket, queue, passive, durable, exclusive, auto_delete, nowait, arguments];
method_fieldnames('queue.declare_ok') -> [queue, message_count, consumer_count];
method_fieldnames('queue.bind') -> [ticket, queue, exchange, routing_key, nowait, arguments];
method_fieldnames('queue.bind_ok') -> [];
method_fieldnames('queue.purge') -> [ticket, queue, nowait];
method_fieldnames('queue.purge_ok') -> [message_count];
method_fieldnames('queue.delete') -> [ticket, queue, if_unused, if_empty, nowait];
method_fieldnames('queue.delete_ok') -> [message_count];
method_fieldnames('queue.unbind') -> [ticket, queue, exchange, routing_key, arguments];
method_fieldnames('queue.unbind_ok') -> [];
method_fieldnames('basic.qos') -> [prefetch_size, prefetch_count, global];
method_fieldnames('basic.qos_ok') -> [];
method_fieldnames('basic.consume') -> [ticket, queue, consumer_tag, no_local, no_ack, exclusive, nowait];
method_fieldnames('basic.consume_ok') -> [consumer_tag];
method_fieldnames('basic.cancel') -> [consumer_tag, nowait];
method_fieldnames('basic.cancel_ok') -> [consumer_tag];
method_fieldnames('basic.publish') -> [ticket, exchange, routing_key, mandatory, immediate];
method_fieldnames('basic.return') -> [reply_code, reply_text, exchange, routing_key];
method_fieldnames('basic.deliver') -> [consumer_tag, delivery_tag, redelivered, exchange, routing_key];
method_fieldnames('basic.get') -> [ticket, queue, no_ack];
method_fieldnames('basic.get_ok') -> [delivery_tag, redelivered, exchange, routing_key, message_count];
method_fieldnames('basic.get_empty') -> [cluster_id];
method_fieldnames('basic.ack') -> [delivery_tag, multiple];
method_fieldnames('basic.reject') -> [delivery_tag, requeue];
method_fieldnames('basic.recover') -> [requeue];
method_fieldnames('file.qos') -> [prefetch_size, prefetch_count, global];
method_fieldnames('file.qos_ok') -> [];
method_fieldnames('file.consume') -> [ticket, queue, consumer_tag, no_local, no_ack, exclusive, nowait];
method_fieldnames('file.consume_ok') -> [consumer_tag];
method_fieldnames('file.cancel') -> [consumer_tag, nowait];
method_fieldnames('file.cancel_ok') -> [consumer_tag];
method_fieldnames('file.open') -> [identifier, content_size];
method_fieldnames('file.open_ok') -> [staged_size];
method_fieldnames('file.stage') -> [];
method_fieldnames('file.publish') -> [ticket, exchange, routing_key, mandatory, immediate, identifier];
method_fieldnames('file.return') -> [reply_code, reply_text, exchange, routing_key];
method_fieldnames('file.deliver') -> [consumer_tag, delivery_tag, redelivered, exchange, routing_key, identifier];
method_fieldnames('file.ack') -> [delivery_tag, multiple];
method_fieldnames('file.reject') -> [delivery_tag, requeue];
method_fieldnames('stream.qos') -> [prefetch_size, prefetch_count, consume_rate, global];
method_fieldnames('stream.qos_ok') -> [];
method_fieldnames('stream.consume') -> [ticket, queue, consumer_tag, no_local, exclusive, nowait];
method_fieldnames('stream.consume_ok') -> [consumer_tag];
method_fieldnames('stream.cancel') -> [consumer_tag, nowait];
method_fieldnames('stream.cancel_ok') -> [consumer_tag];
method_fieldnames('stream.publish') -> [ticket, exchange, routing_key, mandatory, immediate];
method_fieldnames('stream.return') -> [reply_code, reply_text, exchange, routing_key];
method_fieldnames('stream.deliver') -> [consumer_tag, delivery_tag, exchange, queue];
method_fieldnames('tx.select') -> [];
method_fieldnames('tx.select_ok') -> [];
method_fieldnames('tx.commit') -> [];
method_fieldnames('tx.commit_ok') -> [];
method_fieldnames('tx.rollback') -> [];
method_fieldnames('tx.rollback_ok') -> [];
method_fieldnames('dtx.select') -> [];
method_fieldnames('dtx.select_ok') -> [];
method_fieldnames('dtx.start') -> [dtx_identifier];
method_fieldnames('dtx.start_ok') -> [];
method_fieldnames('tunnel.request') -> [meta_data];
method_fieldnames('test.integer') -> [integer_1, integer_2, integer_3, integer_4, operation];
method_fieldnames('test.integer_ok') -> [result];
method_fieldnames('test.string') -> [string_1, string_2, operation];
method_fieldnames('test.string_ok') -> [result];
method_fieldnames('test.table') -> [table, integer_op, string_op];
method_fieldnames('test.table_ok') -> [integer_result, string_result];
method_fieldnames('test.content') -> [];
method_fieldnames('test.content_ok') -> [content_checksum];
method_fieldnames(Name) -> exit({unknown_method_name, Name}).
decode_method_fields('connection.start', <<F0:8/unsigned, F1:8/unsigned, F2Len:32/unsigned, F2Tab:F2Len/binary, F3Len:32/unsigned, F3:F3Len/binary, F4Len:32/unsigned, F4:F4Len/binary>>) ->
  F2 = rabbit_binary_parser:parse_table(F2Tab),
  #'connection.start'{version_major = F0, version_minor = F1, server_properties = F2, mechanisms = F3, locales = F4};
decode_method_fields('connection.start_ok', <<F0Len:32/unsigned, F0Tab:F0Len/binary, F1Len:8/unsigned, F1:F1Len/binary, F2Len:32/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary>>) ->
  F0 = rabbit_binary_parser:parse_table(F0Tab),
  #'connection.start_ok'{client_properties = F0, mechanism = F1, response = F2, locale = F3};
decode_method_fields('connection.secure', <<F0Len:32/unsigned, F0:F0Len/binary>>) ->
  #'connection.secure'{challenge = F0};
decode_method_fields('connection.secure_ok', <<F0Len:32/unsigned, F0:F0Len/binary>>) ->
  #'connection.secure_ok'{response = F0};
decode_method_fields('connection.tune', <<F0:16/unsigned, F1:32/unsigned, F2:16/unsigned>>) ->
  #'connection.tune'{channel_max = F0, frame_max = F1, heartbeat = F2};
decode_method_fields('connection.tune_ok', <<F0:16/unsigned, F1:32/unsigned, F2:16/unsigned>>) ->
  #'connection.tune_ok'{channel_max = F0, frame_max = F1, heartbeat = F2};
decode_method_fields('connection.open', <<F0Len:8/unsigned, F0:F0Len/binary, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8>>) ->
  F2 = ((F2Bits band 1) /= 0),
  #'connection.open'{virtual_host = F0, capabilities = F1, insist = F2};
decode_method_fields('connection.open_ok', <<F0Len:8/unsigned, F0:F0Len/binary>>) ->
  #'connection.open_ok'{known_hosts = F0};
decode_method_fields('connection.redirect', <<F0Len:8/unsigned, F0:F0Len/binary, F1Len:8/unsigned, F1:F1Len/binary>>) ->
  #'connection.redirect'{host = F0, known_hosts = F1};
decode_method_fields('connection.close', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2:16/unsigned, F3:16/unsigned>>) ->
  #'connection.close'{reply_code = F0, reply_text = F1, class_id = F2, method_id = F3};
decode_method_fields('connection.close_ok', <<>>) ->
  #'connection.close_ok'{};
decode_method_fields('channel.open', <<F0Len:8/unsigned, F0:F0Len/binary>>) ->
  #'channel.open'{out_of_band = F0};
decode_method_fields('channel.open_ok', <<>>) ->
  #'channel.open_ok'{};
decode_method_fields('channel.flow', <<F0Bits:8>>) ->
  F0 = ((F0Bits band 1) /= 0),
  #'channel.flow'{active = F0};
decode_method_fields('channel.flow_ok', <<F0Bits:8>>) ->
  F0 = ((F0Bits band 1) /= 0),
  #'channel.flow_ok'{active = F0};
decode_method_fields('channel.alert', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:32/unsigned, F2Tab:F2Len/binary>>) ->
  F2 = rabbit_binary_parser:parse_table(F2Tab),
  #'channel.alert'{reply_code = F0, reply_text = F1, details = F2};
decode_method_fields('channel.close', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2:16/unsigned, F3:16/unsigned>>) ->
  #'channel.close'{reply_code = F0, reply_text = F1, class_id = F2, method_id = F3};
decode_method_fields('channel.close_ok', <<>>) ->
  #'channel.close_ok'{};
decode_method_fields('access.request', <<F0Len:8/unsigned, F0:F0Len/binary, F1Bits:8>>) ->
  F1 = ((F1Bits band 1) /= 0),
  F2 = ((F1Bits band 2) /= 0),
  F3 = ((F1Bits band 4) /= 0),
  F4 = ((F1Bits band 8) /= 0),
  F5 = ((F1Bits band 16) /= 0),
  #'access.request'{realm = F0, exclusive = F1, passive = F2, active = F3, write = F4, read = F5};
decode_method_fields('access.request_ok', <<F0:16/unsigned>>) ->
  #'access.request_ok'{ticket = F0};
decode_method_fields('exchange.declare', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8, F8Len:32/unsigned, F8Tab:F8Len/binary>>) ->
  F3 = ((F3Bits band 1) /= 0),
  F4 = ((F3Bits band 2) /= 0),
  F5 = ((F3Bits band 4) /= 0),
  F6 = ((F3Bits band 8) /= 0),
  F7 = ((F3Bits band 16) /= 0),
  F8 = rabbit_binary_parser:parse_table(F8Tab),
  #'exchange.declare'{ticket = F0, exchange = F1, type = F2, passive = F3, durable = F4, auto_delete = F5, internal = F6, nowait = F7, arguments = F8};
decode_method_fields('exchange.declare_ok', <<>>) ->
  #'exchange.declare_ok'{};
decode_method_fields('exchange.delete', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8>>) ->
  F2 = ((F2Bits band 1) /= 0),
  F3 = ((F2Bits band 2) /= 0),
  #'exchange.delete'{ticket = F0, exchange = F1, if_unused = F2, nowait = F3};
decode_method_fields('exchange.delete_ok', <<>>) ->
  #'exchange.delete_ok'{};
decode_method_fields('queue.declare', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8, F7Len:32/unsigned, F7Tab:F7Len/binary>>) ->
  F2 = ((F2Bits band 1) /= 0),
  F3 = ((F2Bits band 2) /= 0),
  F4 = ((F2Bits band 4) /= 0),
  F5 = ((F2Bits band 8) /= 0),
  F6 = ((F2Bits band 16) /= 0),
  F7 = rabbit_binary_parser:parse_table(F7Tab),
  #'queue.declare'{ticket = F0, queue = F1, passive = F2, durable = F3, exclusive = F4, auto_delete = F5, nowait = F6, arguments = F7};
decode_method_fields('queue.declare_ok', <<F0Len:8/unsigned, F0:F0Len/binary, F1:32/unsigned, F2:32/unsigned>>) ->
  #'queue.declare_ok'{queue = F0, message_count = F1, consumer_count = F2};
decode_method_fields('queue.bind', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary, F4Bits:8, F5Len:32/unsigned, F5Tab:F5Len/binary>>) ->
  F4 = ((F4Bits band 1) /= 0),
  F5 = rabbit_binary_parser:parse_table(F5Tab),
  #'queue.bind'{ticket = F0, queue = F1, exchange = F2, routing_key = F3, nowait = F4, arguments = F5};
decode_method_fields('queue.bind_ok', <<>>) ->
  #'queue.bind_ok'{};
decode_method_fields('queue.purge', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8>>) ->
  F2 = ((F2Bits band 1) /= 0),
  #'queue.purge'{ticket = F0, queue = F1, nowait = F2};
decode_method_fields('queue.purge_ok', <<F0:32/unsigned>>) ->
  #'queue.purge_ok'{message_count = F0};
decode_method_fields('queue.delete', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8>>) ->
  F2 = ((F2Bits band 1) /= 0),
  F3 = ((F2Bits band 2) /= 0),
  F4 = ((F2Bits band 4) /= 0),
  #'queue.delete'{ticket = F0, queue = F1, if_unused = F2, if_empty = F3, nowait = F4};
decode_method_fields('queue.delete_ok', <<F0:32/unsigned>>) ->
  #'queue.delete_ok'{message_count = F0};
decode_method_fields('queue.unbind', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary, F4Len:32/unsigned, F4Tab:F4Len/binary>>) ->
  F4 = rabbit_binary_parser:parse_table(F4Tab),
  #'queue.unbind'{ticket = F0, queue = F1, exchange = F2, routing_key = F3, arguments = F4};
decode_method_fields('queue.unbind_ok', <<>>) ->
  #'queue.unbind_ok'{};
decode_method_fields('basic.qos', <<F0:32/unsigned, F1:16/unsigned, F2Bits:8>>) ->
  F2 = ((F2Bits band 1) /= 0),
  #'basic.qos'{prefetch_size = F0, prefetch_count = F1, global = F2};
decode_method_fields('basic.qos_ok', <<>>) ->
  #'basic.qos_ok'{};
decode_method_fields('basic.consume', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8>>) ->
  F3 = ((F3Bits band 1) /= 0),
  F4 = ((F3Bits band 2) /= 0),
  F5 = ((F3Bits band 4) /= 0),
  F6 = ((F3Bits band 8) /= 0),
  #'basic.consume'{ticket = F0, queue = F1, consumer_tag = F2, no_local = F3, no_ack = F4, exclusive = F5, nowait = F6};
decode_method_fields('basic.consume_ok', <<F0Len:8/unsigned, F0:F0Len/binary>>) ->
  #'basic.consume_ok'{consumer_tag = F0};
decode_method_fields('basic.cancel', <<F0Len:8/unsigned, F0:F0Len/binary, F1Bits:8>>) ->
  F1 = ((F1Bits band 1) /= 0),
  #'basic.cancel'{consumer_tag = F0, nowait = F1};
decode_method_fields('basic.cancel_ok', <<F0Len:8/unsigned, F0:F0Len/binary>>) ->
  #'basic.cancel_ok'{consumer_tag = F0};
decode_method_fields('basic.publish', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8>>) ->
  F3 = ((F3Bits band 1) /= 0),
  F4 = ((F3Bits band 2) /= 0),
  #'basic.publish'{ticket = F0, exchange = F1, routing_key = F2, mandatory = F3, immediate = F4};
decode_method_fields('basic.return', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary>>) ->
  #'basic.return'{reply_code = F0, reply_text = F1, exchange = F2, routing_key = F3};
decode_method_fields('basic.deliver', <<F0Len:8/unsigned, F0:F0Len/binary, F1:64/unsigned, F2Bits:8, F3Len:8/unsigned, F3:F3Len/binary, F4Len:8/unsigned, F4:F4Len/binary>>) ->
  F2 = ((F2Bits band 1) /= 0),
  #'basic.deliver'{consumer_tag = F0, delivery_tag = F1, redelivered = F2, exchange = F3, routing_key = F4};
decode_method_fields('basic.get', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8>>) ->
  F2 = ((F2Bits band 1) /= 0),
  #'basic.get'{ticket = F0, queue = F1, no_ack = F2};
decode_method_fields('basic.get_ok', <<F0:64/unsigned, F1Bits:8, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary, F4:32/unsigned>>) ->
  F1 = ((F1Bits band 1) /= 0),
  #'basic.get_ok'{delivery_tag = F0, redelivered = F1, exchange = F2, routing_key = F3, message_count = F4};
decode_method_fields('basic.get_empty', <<F0Len:8/unsigned, F0:F0Len/binary>>) ->
  #'basic.get_empty'{cluster_id = F0};
decode_method_fields('basic.ack', <<F0:64/unsigned, F1Bits:8>>) ->
  F1 = ((F1Bits band 1) /= 0),
  #'basic.ack'{delivery_tag = F0, multiple = F1};
decode_method_fields('basic.reject', <<F0:64/unsigned, F1Bits:8>>) ->
  F1 = ((F1Bits band 1) /= 0),
  #'basic.reject'{delivery_tag = F0, requeue = F1};
decode_method_fields('basic.recover', <<F0Bits:8>>) ->
  F0 = ((F0Bits band 1) /= 0),
  #'basic.recover'{requeue = F0};
decode_method_fields('file.qos', <<F0:32/unsigned, F1:16/unsigned, F2Bits:8>>) ->
  F2 = ((F2Bits band 1) /= 0),
  #'file.qos'{prefetch_size = F0, prefetch_count = F1, global = F2};
decode_method_fields('file.qos_ok', <<>>) ->
  #'file.qos_ok'{};
decode_method_fields('file.consume', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8>>) ->
  F3 = ((F3Bits band 1) /= 0),
  F4 = ((F3Bits band 2) /= 0),
  F5 = ((F3Bits band 4) /= 0),
  F6 = ((F3Bits band 8) /= 0),
  #'file.consume'{ticket = F0, queue = F1, consumer_tag = F2, no_local = F3, no_ack = F4, exclusive = F5, nowait = F6};
decode_method_fields('file.consume_ok', <<F0Len:8/unsigned, F0:F0Len/binary>>) ->
  #'file.consume_ok'{consumer_tag = F0};
decode_method_fields('file.cancel', <<F0Len:8/unsigned, F0:F0Len/binary, F1Bits:8>>) ->
  F1 = ((F1Bits band 1) /= 0),
  #'file.cancel'{consumer_tag = F0, nowait = F1};
decode_method_fields('file.cancel_ok', <<F0Len:8/unsigned, F0:F0Len/binary>>) ->
  #'file.cancel_ok'{consumer_tag = F0};
decode_method_fields('file.open', <<F0Len:8/unsigned, F0:F0Len/binary, F1:64/unsigned>>) ->
  #'file.open'{identifier = F0, content_size = F1};
decode_method_fields('file.open_ok', <<F0:64/unsigned>>) ->
  #'file.open_ok'{staged_size = F0};
decode_method_fields('file.stage', <<>>) ->
  #'file.stage'{};
decode_method_fields('file.publish', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8, F5Len:8/unsigned, F5:F5Len/binary>>) ->
  F3 = ((F3Bits band 1) /= 0),
  F4 = ((F3Bits band 2) /= 0),
  #'file.publish'{ticket = F0, exchange = F1, routing_key = F2, mandatory = F3, immediate = F4, identifier = F5};
decode_method_fields('file.return', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary>>) ->
  #'file.return'{reply_code = F0, reply_text = F1, exchange = F2, routing_key = F3};
decode_method_fields('file.deliver', <<F0Len:8/unsigned, F0:F0Len/binary, F1:64/unsigned, F2Bits:8, F3Len:8/unsigned, F3:F3Len/binary, F4Len:8/unsigned, F4:F4Len/binary, F5Len:8/unsigned, F5:F5Len/binary>>) ->
  F2 = ((F2Bits band 1) /= 0),
  #'file.deliver'{consumer_tag = F0, delivery_tag = F1, redelivered = F2, exchange = F3, routing_key = F4, identifier = F5};
decode_method_fields('file.ack', <<F0:64/unsigned, F1Bits:8>>) ->
  F1 = ((F1Bits band 1) /= 0),
  #'file.ack'{delivery_tag = F0, multiple = F1};
decode_method_fields('file.reject', <<F0:64/unsigned, F1Bits:8>>) ->
  F1 = ((F1Bits band 1) /= 0),
  #'file.reject'{delivery_tag = F0, requeue = F1};
decode_method_fields('stream.qos', <<F0:32/unsigned, F1:16/unsigned, F2:32/unsigned, F3Bits:8>>) ->
  F3 = ((F3Bits band 1) /= 0),
  #'stream.qos'{prefetch_size = F0, prefetch_count = F1, consume_rate = F2, global = F3};
decode_method_fields('stream.qos_ok', <<>>) ->
  #'stream.qos_ok'{};
decode_method_fields('stream.consume', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8>>) ->
  F3 = ((F3Bits band 1) /= 0),
  F4 = ((F3Bits band 2) /= 0),
  F5 = ((F3Bits band 4) /= 0),
  #'stream.consume'{ticket = F0, queue = F1, consumer_tag = F2, no_local = F3, exclusive = F4, nowait = F5};
decode_method_fields('stream.consume_ok', <<F0Len:8/unsigned, F0:F0Len/binary>>) ->
  #'stream.consume_ok'{consumer_tag = F0};
decode_method_fields('stream.cancel', <<F0Len:8/unsigned, F0:F0Len/binary, F1Bits:8>>) ->
  F1 = ((F1Bits band 1) /= 0),
  #'stream.cancel'{consumer_tag = F0, nowait = F1};
decode_method_fields('stream.cancel_ok', <<F0Len:8/unsigned, F0:F0Len/binary>>) ->
  #'stream.cancel_ok'{consumer_tag = F0};
decode_method_fields('stream.publish', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8>>) ->
  F3 = ((F3Bits band 1) /= 0),
  F4 = ((F3Bits band 2) /= 0),
  #'stream.publish'{ticket = F0, exchange = F1, routing_key = F2, mandatory = F3, immediate = F4};
decode_method_fields('stream.return', <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary>>) ->
  #'stream.return'{reply_code = F0, reply_text = F1, exchange = F2, routing_key = F3};
decode_method_fields('stream.deliver', <<F0Len:8/unsigned, F0:F0Len/binary, F1:64/unsigned, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary>>) ->
  #'stream.deliver'{consumer_tag = F0, delivery_tag = F1, exchange = F2, queue = F3};
decode_method_fields('tx.select', <<>>) ->
  #'tx.select'{};
decode_method_fields('tx.select_ok', <<>>) ->
  #'tx.select_ok'{};
decode_method_fields('tx.commit', <<>>) ->
  #'tx.commit'{};
decode_method_fields('tx.commit_ok', <<>>) ->
  #'tx.commit_ok'{};
decode_method_fields('tx.rollback', <<>>) ->
  #'tx.rollback'{};
decode_method_fields('tx.rollback_ok', <<>>) ->
  #'tx.rollback_ok'{};
decode_method_fields('dtx.select', <<>>) ->
  #'dtx.select'{};
decode_method_fields('dtx.select_ok', <<>>) ->
  #'dtx.select_ok'{};
decode_method_fields('dtx.start', <<F0Len:8/unsigned, F0:F0Len/binary>>) ->
  #'dtx.start'{dtx_identifier = F0};
decode_method_fields('dtx.start_ok', <<>>) ->
  #'dtx.start_ok'{};
decode_method_fields('tunnel.request', <<F0Len:32/unsigned, F0Tab:F0Len/binary>>) ->
  F0 = rabbit_binary_parser:parse_table(F0Tab),
  #'tunnel.request'{meta_data = F0};
decode_method_fields('test.integer', <<F0:8/unsigned, F1:16/unsigned, F2:32/unsigned, F3:64/unsigned, F4:8/unsigned>>) ->
  #'test.integer'{integer_1 = F0, integer_2 = F1, integer_3 = F2, integer_4 = F3, operation = F4};
decode_method_fields('test.integer_ok', <<F0:64/unsigned>>) ->
  #'test.integer_ok'{result = F0};
decode_method_fields('test.string', <<F0Len:8/unsigned, F0:F0Len/binary, F1Len:32/unsigned, F1:F1Len/binary, F2:8/unsigned>>) ->
  #'test.string'{string_1 = F0, string_2 = F1, operation = F2};
decode_method_fields('test.string_ok', <<F0Len:32/unsigned, F0:F0Len/binary>>) ->
  #'test.string_ok'{result = F0};
decode_method_fields('test.table', <<F0Len:32/unsigned, F0Tab:F0Len/binary, F1:8/unsigned, F2:8/unsigned>>) ->
  F0 = rabbit_binary_parser:parse_table(F0Tab),
  #'test.table'{table = F0, integer_op = F1, string_op = F2};
decode_method_fields('test.table_ok', <<F0:64/unsigned, F1Len:32/unsigned, F1:F1Len/binary>>) ->
  #'test.table_ok'{integer_result = F0, string_result = F1};
decode_method_fields('test.content', <<>>) ->
  #'test.content'{};
decode_method_fields('test.content_ok', <<F0:32/unsigned>>) ->
  #'test.content_ok'{content_checksum = F0};
decode_method_fields(Name, BinaryFields) ->
  rabbit_misc:frame_error(Name, BinaryFields).
decode_properties(10, PropBin) ->
  [] = rabbit_binary_parser:parse_properties([], PropBin),
  #'P_connection'{};
decode_properties(20, PropBin) ->
  [] = rabbit_binary_parser:parse_properties([], PropBin),
  #'P_channel'{};
decode_properties(30, PropBin) ->
  [] = rabbit_binary_parser:parse_properties([], PropBin),
  #'P_access'{};
decode_properties(40, PropBin) ->
  [] = rabbit_binary_parser:parse_properties([], PropBin),
  #'P_exchange'{};
decode_properties(50, PropBin) ->
  [] = rabbit_binary_parser:parse_properties([], PropBin),
  #'P_queue'{};
decode_properties(60, PropBin) ->
  [F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13] = rabbit_binary_parser:parse_properties([shortstr, shortstr, table, octet, octet, shortstr, shortstr, shortstr, shortstr, timestamp, shortstr, shortstr, shortstr, shortstr], PropBin),
  #'P_basic'{content_type = F0, content_encoding = F1, headers = F2, delivery_mode = F3, priority = F4, correlation_id = F5, reply_to = F6, expiration = F7, message_id = F8, timestamp = F9, type = F10, user_id = F11, app_id = F12, cluster_id = F13};
decode_properties(70, PropBin) ->
  [F0, F1, F2, F3, F4, F5, F6, F7, F8] = rabbit_binary_parser:parse_properties([shortstr, shortstr, table, octet, shortstr, shortstr, shortstr, timestamp, shortstr], PropBin),
  #'P_file'{content_type = F0, content_encoding = F1, headers = F2, priority = F3, reply_to = F4, message_id = F5, filename = F6, timestamp = F7, cluster_id = F8};
decode_properties(80, PropBin) ->
  [F0, F1, F2, F3, F4] = rabbit_binary_parser:parse_properties([shortstr, shortstr, table, octet, timestamp], PropBin),
  #'P_stream'{content_type = F0, content_encoding = F1, headers = F2, priority = F3, timestamp = F4};
decode_properties(90, PropBin) ->
  [] = rabbit_binary_parser:parse_properties([], PropBin),
  #'P_tx'{};
decode_properties(100, PropBin) ->
  [] = rabbit_binary_parser:parse_properties([], PropBin),
  #'P_dtx'{};
decode_properties(110, PropBin) ->
  [F0, F1, F2, F3, F4] = rabbit_binary_parser:parse_properties([table, shortstr, shortstr, octet, octet], PropBin),
  #'P_tunnel'{headers = F0, proxy_name = F1, data_name = F2, durable = F3, broadcast = F4};
decode_properties(120, PropBin) ->
  [] = rabbit_binary_parser:parse_properties([], PropBin),
  #'P_test'{};
decode_properties(ClassId, _BinaryFields) -> exit({unknown_class_id, ClassId}).
encode_method_fields(#'connection.start'{version_major = F0, version_minor = F1, server_properties = F2, mechanisms = F3, locales = F4}) ->
  F2Tab = rabbit_binary_generator:generate_table(F2),
  F2Len = size(F2Tab),
  F3Len = size(F3),
  F4Len = size(F4),
  <<F0:8/unsigned, F1:8/unsigned, F2Len:32/unsigned, F2Tab:F2Len/binary, F3Len:32/unsigned, F3:F3Len/binary, F4Len:32/unsigned, F4:F4Len/binary>>;
encode_method_fields(#'connection.start_ok'{client_properties = F0, mechanism = F1, response = F2, locale = F3}) ->
  F0Tab = rabbit_binary_generator:generate_table(F0),
  F0Len = size(F0Tab),
  F1Len = size(F1),
  F2Len = size(F2),
  F3Len = size(F3),
  <<F0Len:32/unsigned, F0Tab:F0Len/binary, F1Len:8/unsigned, F1:F1Len/binary, F2Len:32/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary>>;
encode_method_fields(#'connection.secure'{challenge = F0}) ->
  F0Len = size(F0),
  <<F0Len:32/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'connection.secure_ok'{response = F0}) ->
  F0Len = size(F0),
  <<F0Len:32/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'connection.tune'{channel_max = F0, frame_max = F1, heartbeat = F2}) ->
  <<F0:16/unsigned, F1:32/unsigned, F2:16/unsigned>>;
encode_method_fields(#'connection.tune_ok'{channel_max = F0, frame_max = F1, heartbeat = F2}) ->
  <<F0:16/unsigned, F1:32/unsigned, F2:16/unsigned>>;
encode_method_fields(#'connection.open'{virtual_host = F0, capabilities = F1, insist = F2}) ->
  F0Len = size(F0),
  F1Len = size(F1),
  F2Bits = ((bitvalue(F2) bsl 0)),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8>>;
encode_method_fields(#'connection.open_ok'{known_hosts = F0}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'connection.redirect'{host = F0, known_hosts = F1}) ->
  F0Len = size(F0),
  F1Len = size(F1),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1Len:8/unsigned, F1:F1Len/binary>>;
encode_method_fields(#'connection.close'{reply_code = F0, reply_text = F1, class_id = F2, method_id = F3}) ->
  F1Len = size(F1),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2:16/unsigned, F3:16/unsigned>>;
encode_method_fields(#'connection.close_ok'{}) ->
  <<>>;
encode_method_fields(#'channel.open'{out_of_band = F0}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'channel.open_ok'{}) ->
  <<>>;
encode_method_fields(#'channel.flow'{active = F0}) ->
  F0Bits = ((bitvalue(F0) bsl 0)),
  <<F0Bits:8>>;
encode_method_fields(#'channel.flow_ok'{active = F0}) ->
  F0Bits = ((bitvalue(F0) bsl 0)),
  <<F0Bits:8>>;
encode_method_fields(#'channel.alert'{reply_code = F0, reply_text = F1, details = F2}) ->
  F1Len = size(F1),
  F2Tab = rabbit_binary_generator:generate_table(F2),
  F2Len = size(F2Tab),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:32/unsigned, F2Tab:F2Len/binary>>;
encode_method_fields(#'channel.close'{reply_code = F0, reply_text = F1, class_id = F2, method_id = F3}) ->
  F1Len = size(F1),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2:16/unsigned, F3:16/unsigned>>;
encode_method_fields(#'channel.close_ok'{}) ->
  <<>>;
encode_method_fields(#'access.request'{realm = F0, exclusive = F1, passive = F2, active = F3, write = F4, read = F5}) ->
  F0Len = size(F0),
  F1Bits = ((bitvalue(F1) bsl 0) bor (bitvalue(F2) bsl 1) bor (bitvalue(F3) bsl 2) bor (bitvalue(F4) bsl 3) bor (bitvalue(F5) bsl 4)),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1Bits:8>>;
encode_method_fields(#'access.request_ok'{ticket = F0}) ->
  <<F0:16/unsigned>>;
encode_method_fields(#'exchange.declare'{ticket = F0, exchange = F1, type = F2, passive = F3, durable = F4, auto_delete = F5, internal = F6, nowait = F7, arguments = F8}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Bits = ((bitvalue(F3) bsl 0) bor (bitvalue(F4) bsl 1) bor (bitvalue(F5) bsl 2) bor (bitvalue(F6) bsl 3) bor (bitvalue(F7) bsl 4)),
  F8Tab = rabbit_binary_generator:generate_table(F8),
  F8Len = size(F8Tab),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8, F8Len:32/unsigned, F8Tab:F8Len/binary>>;
encode_method_fields(#'exchange.declare_ok'{}) ->
  <<>>;
encode_method_fields(#'exchange.delete'{ticket = F0, exchange = F1, if_unused = F2, nowait = F3}) ->
  F1Len = size(F1),
  F2Bits = ((bitvalue(F2) bsl 0) bor (bitvalue(F3) bsl 1)),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8>>;
encode_method_fields(#'exchange.delete_ok'{}) ->
  <<>>;
encode_method_fields(#'queue.declare'{ticket = F0, queue = F1, passive = F2, durable = F3, exclusive = F4, auto_delete = F5, nowait = F6, arguments = F7}) ->
  F1Len = size(F1),
  F2Bits = ((bitvalue(F2) bsl 0) bor (bitvalue(F3) bsl 1) bor (bitvalue(F4) bsl 2) bor (bitvalue(F5) bsl 3) bor (bitvalue(F6) bsl 4)),
  F7Tab = rabbit_binary_generator:generate_table(F7),
  F7Len = size(F7Tab),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8, F7Len:32/unsigned, F7Tab:F7Len/binary>>;
encode_method_fields(#'queue.declare_ok'{queue = F0, message_count = F1, consumer_count = F2}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1:32/unsigned, F2:32/unsigned>>;
encode_method_fields(#'queue.bind'{ticket = F0, queue = F1, exchange = F2, routing_key = F3, nowait = F4, arguments = F5}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Len = size(F3),
  F4Bits = ((bitvalue(F4) bsl 0)),
  F5Tab = rabbit_binary_generator:generate_table(F5),
  F5Len = size(F5Tab),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary, F4Bits:8, F5Len:32/unsigned, F5Tab:F5Len/binary>>;
encode_method_fields(#'queue.bind_ok'{}) ->
  <<>>;
encode_method_fields(#'queue.purge'{ticket = F0, queue = F1, nowait = F2}) ->
  F1Len = size(F1),
  F2Bits = ((bitvalue(F2) bsl 0)),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8>>;
encode_method_fields(#'queue.purge_ok'{message_count = F0}) ->
  <<F0:32/unsigned>>;
encode_method_fields(#'queue.delete'{ticket = F0, queue = F1, if_unused = F2, if_empty = F3, nowait = F4}) ->
  F1Len = size(F1),
  F2Bits = ((bitvalue(F2) bsl 0) bor (bitvalue(F3) bsl 1) bor (bitvalue(F4) bsl 2)),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8>>;
encode_method_fields(#'queue.delete_ok'{message_count = F0}) ->
  <<F0:32/unsigned>>;
encode_method_fields(#'queue.unbind'{ticket = F0, queue = F1, exchange = F2, routing_key = F3, arguments = F4}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Len = size(F3),
  F4Tab = rabbit_binary_generator:generate_table(F4),
  F4Len = size(F4Tab),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary, F4Len:32/unsigned, F4Tab:F4Len/binary>>;
encode_method_fields(#'queue.unbind_ok'{}) ->
  <<>>;
encode_method_fields(#'basic.qos'{prefetch_size = F0, prefetch_count = F1, global = F2}) ->
  F2Bits = ((bitvalue(F2) bsl 0)),
  <<F0:32/unsigned, F1:16/unsigned, F2Bits:8>>;
encode_method_fields(#'basic.qos_ok'{}) ->
  <<>>;
encode_method_fields(#'basic.consume'{ticket = F0, queue = F1, consumer_tag = F2, no_local = F3, no_ack = F4, exclusive = F5, nowait = F6}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Bits = ((bitvalue(F3) bsl 0) bor (bitvalue(F4) bsl 1) bor (bitvalue(F5) bsl 2) bor (bitvalue(F6) bsl 3)),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8>>;
encode_method_fields(#'basic.consume_ok'{consumer_tag = F0}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'basic.cancel'{consumer_tag = F0, nowait = F1}) ->
  F0Len = size(F0),
  F1Bits = ((bitvalue(F1) bsl 0)),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1Bits:8>>;
encode_method_fields(#'basic.cancel_ok'{consumer_tag = F0}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'basic.publish'{ticket = F0, exchange = F1, routing_key = F2, mandatory = F3, immediate = F4}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Bits = ((bitvalue(F3) bsl 0) bor (bitvalue(F4) bsl 1)),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8>>;
encode_method_fields(#'basic.return'{reply_code = F0, reply_text = F1, exchange = F2, routing_key = F3}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Len = size(F3),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary>>;
encode_method_fields(#'basic.deliver'{consumer_tag = F0, delivery_tag = F1, redelivered = F2, exchange = F3, routing_key = F4}) ->
  F0Len = size(F0),
  F2Bits = ((bitvalue(F2) bsl 0)),
  F3Len = size(F3),
  F4Len = size(F4),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1:64/unsigned, F2Bits:8, F3Len:8/unsigned, F3:F3Len/binary, F4Len:8/unsigned, F4:F4Len/binary>>;
encode_method_fields(#'basic.get'{ticket = F0, queue = F1, no_ack = F2}) ->
  F1Len = size(F1),
  F2Bits = ((bitvalue(F2) bsl 0)),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Bits:8>>;
encode_method_fields(#'basic.get_ok'{delivery_tag = F0, redelivered = F1, exchange = F2, routing_key = F3, message_count = F4}) ->
  F1Bits = ((bitvalue(F1) bsl 0)),
  F2Len = size(F2),
  F3Len = size(F3),
  <<F0:64/unsigned, F1Bits:8, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary, F4:32/unsigned>>;
encode_method_fields(#'basic.get_empty'{cluster_id = F0}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'basic.ack'{delivery_tag = F0, multiple = F1}) ->
  F1Bits = ((bitvalue(F1) bsl 0)),
  <<F0:64/unsigned, F1Bits:8>>;
encode_method_fields(#'basic.reject'{delivery_tag = F0, requeue = F1}) ->
  F1Bits = ((bitvalue(F1) bsl 0)),
  <<F0:64/unsigned, F1Bits:8>>;
encode_method_fields(#'basic.recover'{requeue = F0}) ->
  F0Bits = ((bitvalue(F0) bsl 0)),
  <<F0Bits:8>>;
encode_method_fields(#'file.qos'{prefetch_size = F0, prefetch_count = F1, global = F2}) ->
  F2Bits = ((bitvalue(F2) bsl 0)),
  <<F0:32/unsigned, F1:16/unsigned, F2Bits:8>>;
encode_method_fields(#'file.qos_ok'{}) ->
  <<>>;
encode_method_fields(#'file.consume'{ticket = F0, queue = F1, consumer_tag = F2, no_local = F3, no_ack = F4, exclusive = F5, nowait = F6}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Bits = ((bitvalue(F3) bsl 0) bor (bitvalue(F4) bsl 1) bor (bitvalue(F5) bsl 2) bor (bitvalue(F6) bsl 3)),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8>>;
encode_method_fields(#'file.consume_ok'{consumer_tag = F0}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'file.cancel'{consumer_tag = F0, nowait = F1}) ->
  F0Len = size(F0),
  F1Bits = ((bitvalue(F1) bsl 0)),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1Bits:8>>;
encode_method_fields(#'file.cancel_ok'{consumer_tag = F0}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'file.open'{identifier = F0, content_size = F1}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1:64/unsigned>>;
encode_method_fields(#'file.open_ok'{staged_size = F0}) ->
  <<F0:64/unsigned>>;
encode_method_fields(#'file.stage'{}) ->
  <<>>;
encode_method_fields(#'file.publish'{ticket = F0, exchange = F1, routing_key = F2, mandatory = F3, immediate = F4, identifier = F5}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Bits = ((bitvalue(F3) bsl 0) bor (bitvalue(F4) bsl 1)),
  F5Len = size(F5),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8, F5Len:8/unsigned, F5:F5Len/binary>>;
encode_method_fields(#'file.return'{reply_code = F0, reply_text = F1, exchange = F2, routing_key = F3}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Len = size(F3),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary>>;
encode_method_fields(#'file.deliver'{consumer_tag = F0, delivery_tag = F1, redelivered = F2, exchange = F3, routing_key = F4, identifier = F5}) ->
  F0Len = size(F0),
  F2Bits = ((bitvalue(F2) bsl 0)),
  F3Len = size(F3),
  F4Len = size(F4),
  F5Len = size(F5),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1:64/unsigned, F2Bits:8, F3Len:8/unsigned, F3:F3Len/binary, F4Len:8/unsigned, F4:F4Len/binary, F5Len:8/unsigned, F5:F5Len/binary>>;
encode_method_fields(#'file.ack'{delivery_tag = F0, multiple = F1}) ->
  F1Bits = ((bitvalue(F1) bsl 0)),
  <<F0:64/unsigned, F1Bits:8>>;
encode_method_fields(#'file.reject'{delivery_tag = F0, requeue = F1}) ->
  F1Bits = ((bitvalue(F1) bsl 0)),
  <<F0:64/unsigned, F1Bits:8>>;
encode_method_fields(#'stream.qos'{prefetch_size = F0, prefetch_count = F1, consume_rate = F2, global = F3}) ->
  F3Bits = ((bitvalue(F3) bsl 0)),
  <<F0:32/unsigned, F1:16/unsigned, F2:32/unsigned, F3Bits:8>>;
encode_method_fields(#'stream.qos_ok'{}) ->
  <<>>;
encode_method_fields(#'stream.consume'{ticket = F0, queue = F1, consumer_tag = F2, no_local = F3, exclusive = F4, nowait = F5}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Bits = ((bitvalue(F3) bsl 0) bor (bitvalue(F4) bsl 1) bor (bitvalue(F5) bsl 2)),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8>>;
encode_method_fields(#'stream.consume_ok'{consumer_tag = F0}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'stream.cancel'{consumer_tag = F0, nowait = F1}) ->
  F0Len = size(F0),
  F1Bits = ((bitvalue(F1) bsl 0)),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1Bits:8>>;
encode_method_fields(#'stream.cancel_ok'{consumer_tag = F0}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'stream.publish'{ticket = F0, exchange = F1, routing_key = F2, mandatory = F3, immediate = F4}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Bits = ((bitvalue(F3) bsl 0) bor (bitvalue(F4) bsl 1)),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Bits:8>>;
encode_method_fields(#'stream.return'{reply_code = F0, reply_text = F1, exchange = F2, routing_key = F3}) ->
  F1Len = size(F1),
  F2Len = size(F2),
  F3Len = size(F3),
  <<F0:16/unsigned, F1Len:8/unsigned, F1:F1Len/binary, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary>>;
encode_method_fields(#'stream.deliver'{consumer_tag = F0, delivery_tag = F1, exchange = F2, queue = F3}) ->
  F0Len = size(F0),
  F2Len = size(F2),
  F3Len = size(F3),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1:64/unsigned, F2Len:8/unsigned, F2:F2Len/binary, F3Len:8/unsigned, F3:F3Len/binary>>;
encode_method_fields(#'tx.select'{}) ->
  <<>>;
encode_method_fields(#'tx.select_ok'{}) ->
  <<>>;
encode_method_fields(#'tx.commit'{}) ->
  <<>>;
encode_method_fields(#'tx.commit_ok'{}) ->
  <<>>;
encode_method_fields(#'tx.rollback'{}) ->
  <<>>;
encode_method_fields(#'tx.rollback_ok'{}) ->
  <<>>;
encode_method_fields(#'dtx.select'{}) ->
  <<>>;
encode_method_fields(#'dtx.select_ok'{}) ->
  <<>>;
encode_method_fields(#'dtx.start'{dtx_identifier = F0}) ->
  F0Len = size(F0),
  <<F0Len:8/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'dtx.start_ok'{}) ->
  <<>>;
encode_method_fields(#'tunnel.request'{meta_data = F0}) ->
  F0Tab = rabbit_binary_generator:generate_table(F0),
  F0Len = size(F0Tab),
  <<F0Len:32/unsigned, F0Tab:F0Len/binary>>;
encode_method_fields(#'test.integer'{integer_1 = F0, integer_2 = F1, integer_3 = F2, integer_4 = F3, operation = F4}) ->
  <<F0:8/unsigned, F1:16/unsigned, F2:32/unsigned, F3:64/unsigned, F4:8/unsigned>>;
encode_method_fields(#'test.integer_ok'{result = F0}) ->
  <<F0:64/unsigned>>;
encode_method_fields(#'test.string'{string_1 = F0, string_2 = F1, operation = F2}) ->
  F0Len = size(F0),
  F1Len = size(F1),
  <<F0Len:8/unsigned, F0:F0Len/binary, F1Len:32/unsigned, F1:F1Len/binary, F2:8/unsigned>>;
encode_method_fields(#'test.string_ok'{result = F0}) ->
  F0Len = size(F0),
  <<F0Len:32/unsigned, F0:F0Len/binary>>;
encode_method_fields(#'test.table'{table = F0, integer_op = F1, string_op = F2}) ->
  F0Tab = rabbit_binary_generator:generate_table(F0),
  F0Len = size(F0Tab),
  <<F0Len:32/unsigned, F0Tab:F0Len/binary, F1:8/unsigned, F2:8/unsigned>>;
encode_method_fields(#'test.table_ok'{integer_result = F0, string_result = F1}) ->
  F1Len = size(F1),
  <<F0:64/unsigned, F1Len:32/unsigned, F1:F1Len/binary>>;
encode_method_fields(#'test.content'{}) ->
  <<>>;
encode_method_fields(#'test.content_ok'{content_checksum = F0}) ->
  <<F0:32/unsigned>>;
encode_method_fields(Record) -> exit({unknown_method_name, element(1, Record)}).
encode_properties(#'P_connection'{}) ->
  rabbit_binary_generator:encode_properties([], []);
encode_properties(#'P_channel'{}) ->
  rabbit_binary_generator:encode_properties([], []);
encode_properties(#'P_access'{}) ->
  rabbit_binary_generator:encode_properties([], []);
encode_properties(#'P_exchange'{}) ->
  rabbit_binary_generator:encode_properties([], []);
encode_properties(#'P_queue'{}) ->
  rabbit_binary_generator:encode_properties([], []);
encode_properties(#'P_basic'{content_type = F0, content_encoding = F1, headers = F2, delivery_mode = F3, priority = F4, correlation_id = F5, reply_to = F6, expiration = F7, message_id = F8, timestamp = F9, type = F10, user_id = F11, app_id = F12, cluster_id = F13}) ->
  rabbit_binary_generator:encode_properties([shortstr, shortstr, table, octet, octet, shortstr, shortstr, shortstr, shortstr, timestamp, shortstr, shortstr, shortstr, shortstr], [F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13]);
encode_properties(#'P_file'{content_type = F0, content_encoding = F1, headers = F2, priority = F3, reply_to = F4, message_id = F5, filename = F6, timestamp = F7, cluster_id = F8}) ->
  rabbit_binary_generator:encode_properties([shortstr, shortstr, table, octet, shortstr, shortstr, shortstr, timestamp, shortstr], [F0, F1, F2, F3, F4, F5, F6, F7, F8]);
encode_properties(#'P_stream'{content_type = F0, content_encoding = F1, headers = F2, priority = F3, timestamp = F4}) ->
  rabbit_binary_generator:encode_properties([shortstr, shortstr, table, octet, timestamp], [F0, F1, F2, F3, F4]);
encode_properties(#'P_tx'{}) ->
  rabbit_binary_generator:encode_properties([], []);
encode_properties(#'P_dtx'{}) ->
  rabbit_binary_generator:encode_properties([], []);
encode_properties(#'P_tunnel'{headers = F0, proxy_name = F1, data_name = F2, durable = F3, broadcast = F4}) ->
  rabbit_binary_generator:encode_properties([table, shortstr, shortstr, octet, octet], [F0, F1, F2, F3, F4]);
encode_properties(#'P_test'{}) ->
  rabbit_binary_generator:encode_properties([], []);
encode_properties(Record) -> exit({unknown_properties_record, Record}).
lookup_amqp_exception(not_delivered) -> {false, ?NOT_DELIVERED, <<"NOT_DELIVERED">>};
lookup_amqp_exception(content_too_large) -> {false, ?CONTENT_TOO_LARGE, <<"CONTENT_TOO_LARGE">>};
lookup_amqp_exception(no_route) -> {false, ?NO_ROUTE, <<"NO_ROUTE">>};
lookup_amqp_exception(no_consumers) -> {false, ?NO_CONSUMERS, <<"NO_CONSUMERS">>};
lookup_amqp_exception(access_refused) -> {false, ?ACCESS_REFUSED, <<"ACCESS_REFUSED">>};
lookup_amqp_exception(not_found) -> {false, ?NOT_FOUND, <<"NOT_FOUND">>};
lookup_amqp_exception(resource_locked) -> {false, ?RESOURCE_LOCKED, <<"RESOURCE_LOCKED">>};
lookup_amqp_exception(precondition_failed) -> {false, ?PRECONDITION_FAILED, <<"PRECONDITION_FAILED">>};
lookup_amqp_exception(connection_forced) -> {true, ?CONNECTION_FORCED, <<"CONNECTION_FORCED">>};
lookup_amqp_exception(invalid_path) -> {true, ?INVALID_PATH, <<"INVALID_PATH">>};
lookup_amqp_exception(frame_error) -> {true, ?FRAME_ERROR, <<"FRAME_ERROR">>};
lookup_amqp_exception(syntax_error) -> {true, ?SYNTAX_ERROR, <<"SYNTAX_ERROR">>};
lookup_amqp_exception(command_invalid) -> {true, ?COMMAND_INVALID, <<"COMMAND_INVALID">>};
lookup_amqp_exception(channel_error) -> {true, ?CHANNEL_ERROR, <<"CHANNEL_ERROR">>};
lookup_amqp_exception(resource_error) -> {true, ?RESOURCE_ERROR, <<"RESOURCE_ERROR">>};
lookup_amqp_exception(not_allowed) -> {true, ?NOT_ALLOWED, <<"NOT_ALLOWED">>};
lookup_amqp_exception(not_implemented) -> {true, ?NOT_IMPLEMENTED, <<"NOT_IMPLEMENTED">>};
lookup_amqp_exception(internal_error) -> {true, ?INTERNAL_ERROR, <<"INTERNAL_ERROR">>};
lookup_amqp_exception(Code) ->
  rabbit_log:warning("Unknown AMQP error code '~p'~n", [Code]),
  {true, ?INTERNAL_ERROR, <<"INTERNAL_ERROR">>}.
