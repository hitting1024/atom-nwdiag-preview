AtomNwdiagPreviewView = require './atom-nwdiag-preview-view'
{CompositeDisposable} = require 'atom'

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
      return unless protocol is "atom-nwdiag-preview:"

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
    if atom.workspace.getActivePaneItem() instanceof AtomNwdiagPreviewView
      atom.workspace.destroyActivePaneItem()
      return

    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    @openPreview(editor)

  openPreview: (editor) ->
    uri = "atom-nwdiag-preview://editor/#{editor.id}"
    if atom.workspace.paneForURI(uri)?
      # already open preview
      return

    currentActivePane = atom.workspace.getActivePane()
    options =
      split: 'right'
      searchAllPane: true
    atom.workspace.open(uri, options).done (view) ->
      if view instanceof AtomNwdiagPreviewView
        currentActivePane.activate()
