AtomNwdiagPreviewView = require './atom-nwdiag-preview-view'
{CompositeDisposable} = require 'atom'

ATOM_NWDIAG_PREVIEW_PROTOCOL = "atom-nwdiag-preview"

module.exports = AtomNwdiagPreview =
  atomNwdiagPreviewView: null
  subscriptions: null

  activate: (state) ->
    @atomNwdiagPreviewView = new AtomNwdiagPreviewView(state.atomNwdiagPreviewViewState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-nwdiag-preview:toggle': => @toggle()

    # define opener
    atom.workspace.addOpener (targetUrl) ->
      try
        url = require 'url'
        {protocol, host, pathname} = url.parse(targetUrl)
      catch error
        console.error error
        return
      # check protocol
      return unless protocol is "#{ATOM_NWDIAG_PREVIEW_PROTOCOL}:"

      try
        pathname = decodeURI(pathname) if pathname
      catch error
        console.error error
        return

      new AtomNwdiagPreviewView editorId: pathname.substring(1)

  deactivate: ->
    @subscriptions.dispose()
    @atomNwdiagPreviewView.destroy()

  serialize: ->
    atomNwdiagPreviewViewState: @atomNwdiagPreviewView.serialize()

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    atom.workspace.open("#{ATOM_NWDIAG_PREVIEW_PROTOCOL}://editor/#{editor.id}")
