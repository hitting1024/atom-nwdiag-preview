AtomNwdiagPreviewView = require './atom-nwdiag-preview-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomNwdiagPreview =
  atomNwdiagPreviewView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomNwdiagPreviewView = new AtomNwdiagPreviewView(state.atomNwdiagPreviewViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomNwdiagPreviewView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-nwdiag-preview:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomNwdiagPreviewView.destroy()

  serialize: ->
    atomNwdiagPreviewViewState: @atomNwdiagPreviewView.serialize()

  toggle: ->
    console.log 'AtomNwdiagPreview was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
