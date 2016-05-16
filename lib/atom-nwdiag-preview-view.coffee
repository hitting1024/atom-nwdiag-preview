{View} = require 'space-pen'

module.exports =
class AtomNwdiagPreviewView extends View
  @content: ->
    @div class: 'atom-nwdiag-preview', =>
      @div outlet: "container"

  constructor: ({@editorId}) ->
    super
    @container.html "Hello World #{@editorId}"

  getTitle: ->
    "#{@editorId} nwdiag preview"

  getURI: ->
    "atom-nwdiag-preview://editor/#{@editorId}" if @editorId?
