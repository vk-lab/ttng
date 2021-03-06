# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module RenderSortableTreeHelper
  module Render
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @h, @options = h, options
        node = options[:node]

        expand_button = "<b class='expand'>+</b>"

        "
          <li data-node-id='#{ node.id }'>
            <div class='item'>
              <i class='handle glyphicon glyphicon-option-vertical'></i>
              <i class='handle'></i>
              #{ expand_button if children }
              #{ show_link }
              #{ controls }
            </div>
            #{ children }
          </li>
        "
      end

      def show_link
        node = options[:node]
        ns   = options[:namespace]
        url = h.url_for(:controller => options[:klass].pluralize, :action => :show, :id => node)
        title_field = 'name'

        "<h4>#{ h.link_to(node.send(title_field) + '(' + String(Category.find(node).wiki_pages.count + node.nested_articles_count) + ')', url) }</h4>"
      end

      def controls
        node = options[:node]

        edit_path = h.url_for(:controller => options[:klass].pluralize, :action => :edit, :id => node)
        destroy_path = h.url_for(:controller => options[:klass].pluralize, :action => :destroy, :id => node)

        "
          <div class='controls btn-group btn-group-xs'>
            <a href='#{edit_path}'' class='btn btn-default'>
              <span class='glyphicon glyphicon-pencil'></span>
            </a>
            <a data-method='delete' class='btn btn-default' href='#{destroy_path}' data-confirm='This will delete all child category! Are you sure?'>
              <span class='glyphicon glyphicon-remove'></span>
            </a>


        "
      end

      def children
        unless options[:children].blank?
          "<ol class='nested_set'>#{ options[:children] }</ol>"
        end
      end

    end
  end
end
