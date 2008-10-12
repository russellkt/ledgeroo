module FormsHelper
  def form_field label, field, options={}
    form_stuff = form_field_sans_p(label, field, options)
    the_p     = content_tag('p', form_stuff, :class => "formfield #{options[:class]}")
  end

  def required_form_field label, field, options={}
    options[:class] = options[:class].to_s + " required"
    form_field label, field, options
  end

  def form_field_sans_p label, field, options={}
    the_label = content_tag('label', label, :class => options[:class], :for => options[:for])
    clear     = content_tag('div', '', :class => 'clear')
    output    = the_label + field + clear
  end

end
