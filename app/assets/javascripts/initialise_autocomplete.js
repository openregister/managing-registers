window.onload = function () {

    $('.autocomplete').each(function() {
        accessibleAutocomplete.enhanceSelectElement({
            defaultValue: '',
            selectElement: document.querySelector('#' + this.id)
        })
    })

    $(document).on("fields_added.nested_form_fields", function(event) {
        accessibleAutocomplete.enhanceSelectElement({
            defaultValue: '',
            selectElement: document.querySelector('#' + jQuery(event.target).find("select")[0].id)
        })
    })
}