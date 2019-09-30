//= require rails-ujs
//= require jquery

$(document).on("turbolinks:load", function() {
  return App.cable.subscriptions.create({
    channel: "ConversationChannel",
    id: $('#channel-id').attr('data-conversation-id')
  }, {
    connected: function() {
      console.log("connected");
    },

    disconnected: function() {
      console.log("disconnected");
    },

    rejected: function() {
      console.log("rejected");
    },

    received: function(data) {
      console.log(data);
      var msg = '<div class="uk-card uk-card-body uk-padding-small"><div class="uk-border-rounded uk-card uk-card-body uk-card-default uk-padding-small uk-padding-remove-bottom uk-padding-remove-top uk-align-left uk-margin-small-left", style: "word-wrap: break-word; max-width: 60%; display: block;">' + data + "</div></div>";
      $(".new_message").before(msg);
      var middle;
      if($("#Middle") != null) middle = $("#Middle");
      else middle = $("#Middle_phone");
      middle.animate({ scrollTop: middle.prop("scrollHeight") }, 500);
    }
  });
});
/*
App.cable.subscriptions.create(
  { channel: "ConversationChannel", id: 1 },
  {
    connected: function() {
      console.log("connected");
    },

    disconnected: function() {
      console.log("disconnected");
    },

    rejected: function() {
      console.log("rejected");
    },

    received: function(data) {
      console.log(data);
    }
  }
);*/