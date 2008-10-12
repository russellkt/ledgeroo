module ToolbarHelper
  def toolbar
    render :partial => 'toolbar'
  end
  def render_toolbar array
    render :partial => 'shared/toolbar', :locals => { :array => array }
  end
end
