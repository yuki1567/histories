import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const html = `<div class="comment mt-3 border-bottom"><p>${data.content.created_at.slice(0,10)}</p><p>${data.content.text}</p></div>`;
    const comments = document.getElementById('comments');
    const newComment = document.getElementById('comment_text');
    comments.insertAdjacentHTML('afterbegin', html);
    newComment.value='';
    const submit = document.getElementById('submit');
    submit.removeAttribute("disabled")
  }
});
