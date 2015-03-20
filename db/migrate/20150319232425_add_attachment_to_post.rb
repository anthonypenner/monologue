class AddAttachmentToPost < ActiveRecord::Migration
  def self.up
    add_attachment :monologue_posts, :landscape
  end

  def self.down
    remove_attachment :monologue_posts, :landscape
  end
end
