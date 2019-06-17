-module(post).
-compile(export_all).
-include_lib("kvs/include/entry.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/n2o.hrl").
-include_lib("records.hrl").

post_id() ->
  try binary_to_integer(nitro:qc(id)) catch _:_ -> 0 end.

comments() ->
  [
    #textarea{id=comment, class=["form-control"], rows=3},
    #button{id=send, class=["btn", "btn-default"], body="Post comment",postback=comment,source=[comment]}
  ].

event(init) ->
  % Id = try binary_to_integer(nitro:qc(id)) catch _:_ -> 0 end,
  Id = post_id(),
  
  n2o:reg({post, Id}),

  Post = posts:get(Id),
  nitro:update(header, Post#post.title),
  nitro:update(text, #p{id=text, body=nitro:js_escape(Post#post.text)}),
  nitro:update(comment, comments());

event(comment) ->
  % nitro:insert_bottom(comments, #blockquote{body = #p{body = nitro:q(comment)}}).
  n2o:send({post, post_id()}, {client, nitro:q(comment)});

event({client, Text}) ->
  nitro:insert_bottom(comments, #blockquote{body = #p{body = Text}}).
