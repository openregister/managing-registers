module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.map { |k, v| content_tag(:li, link_to("Your #{k.to_s.humanize} #{v}", "##{resource.class.model_name.to_s.downcase}_#{k}")) }.join
    headline = "Please correct the #{'error'.pluralize(resource.errors.count)} below"

    html = <<-HTML

  <div class="error-summary" role="alert" aria-labelledby="error-summary-heading" tabindex="-1">

        <h2 class="heading-medium error-summary-heading" id="error-summary-heading">
          #{headline}
        </h2>


        <ul class="error-summary-list">
          #{messages}
        </ul>

      </div>
    HTML

    html.html_safe
  end
end
