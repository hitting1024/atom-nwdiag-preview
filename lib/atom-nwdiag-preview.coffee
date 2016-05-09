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

  deactivate: ->
    @subscriptions.dispose()
    @atomNwdiagPreviewView.destroy()

  serialize: ->
    atomNwdiagPreviewViewState: @atomNwdiagPreviewView.serialize()

  toggle: ->
    console.log 'AtomNwdiagPreview was toggled!'
    atom.workspace.open()
