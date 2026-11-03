# Toggles any element with `data-accordion-toggle` and the panel named by its `aria-controls`.
# With `data-accordion-src="url"`, the panel content is loaded the first time it is expanded.
#
# Live updates replace the page content, so panels the user toggled are restored after each update.

$document = $(document)

SLIDE_DURATION = 200

toggledPanels = {}
loadedContent = {}
pendingRequests = {}

loadPanel = ($toggle, panelId) ->
  src = $toggle.data('accordion-src')
  return unless src

  if loadedContent[src]?
    $(document.getElementById(panelId)).html(loadedContent[src])
    return

  $(document.getElementById(panelId)).html('<p class="accordion-message">Loading…</p>')
  return if pendingRequests[src]

  request = pendingRequests[src] = $.get(src)
  request.done (html) ->
    loadedContent[src] = html
    $(document.getElementById(panelId)).html(html)
  request.fail ->
    $(document.getElementById(panelId)).html('<p class="accordion-message">Could not load commits.</p>')
  request.always ->
    delete pendingRequests[src]

slideDuration = ->
  if window.matchMedia?('(prefers-reduced-motion: reduce)').matches then 0 else SLIDE_DURATION

# The `hidden` attribute holds the state; the slide only animates the change and leaves no inline styles behind.
setExpanded = ($toggle, expanded, animate = false) ->
  panelId = $toggle.attr('aria-controls')
  $panel = $(document.getElementById(panelId)).stop(true, true)
  $toggle.attr('aria-expanded', String(expanded))
  loadPanel($toggle, panelId) if expanded
  duration = if animate then slideDuration() else 0

  if expanded
    $panel.prop('hidden', false).css('display', '')
    $panel.hide().slideDown(duration, -> $panel.css('display', '')) if duration
  else if duration
    $panel.slideUp(duration, -> $panel.prop('hidden', true).css('display', ''))
  else
    $panel.prop('hidden', true).css('display', '')

restoreState = ->
  $('[data-accordion-toggle]').each ->
    $toggle = $(this)
    expanded = toggledPanels[$toggle.attr('aria-controls')]
    setExpanded($toggle, expanded) if expanded?

$document.on 'click', '[data-accordion-toggle]', (event) ->
  $toggle = $(event.currentTarget)
  expanded = $toggle.attr('aria-expanded') != 'true'
  setExpanded($toggle, expanded, true)
  toggledPanels[$toggle.attr('aria-controls')] = expanded

$document.on 'shipit:page-updated', restoreState

jQuery restoreState
