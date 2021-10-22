class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      ActionCable.server.broadcast 'comment_channel', content: @comment
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(book_id: params[:book_id])
  end
end
