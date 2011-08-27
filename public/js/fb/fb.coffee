root = global? || window
window.module = (name) ->
    root[name] = root[name] or {}

class fb

    main: ->

        Workspace = Backbone.Router.extend

          initialize: ->
            @fretboard = new modules.fretboard
            @staff = new modules.staff
            @modes = $ '#modes'
            @root = $ '#root'
            Backbone.history.start()

          routes:
            "": "root"
            #TODO - notes, noteNames
            #"notes": "notes"
            #"notes/names": "noteNames"
            "scale/:key/:mode": "scale"

          root: ->
            @fretboard.init()
            @navigate 'scale/c/ionian', 'triggerRoute'

          notes: ->
            @fretboard.init().drawNotes()

          noteNames: (query, page) ->
            @fretboard.init().drawNotes noteNames: true

          scale: (key, mode) ->

            @bindModes()

            key = key || 'C'
            key = key.toUpperCase()
            mode = mode || 'ionian'

            @scale = new Scale
            @scale.bind 'change', =>
                @modelChange()
            @scale.set(
                { mode: mode, key: key }
            )

            @paintControls(mode, key)

            @view = new View
                model: @scale
                el: $ 'body'

            $(document).keydown (e) =>
                @keyDown(e, @view)

          paintControls: (mode, key) ->
            @modes.val(mode)
            mode = mode.capitalize()
            key = key.capitalize()
            @root.val(key)
            $('#contextMode').html("<a target='_blank' href='http://en.wikipedia.org/wiki/#{mode}_mode'>#{mode}</a>")
            $('#contextRoot').html("<a target='_blank' href='http://en.wikipedia.org/wiki/Key_of_#{key}'>#{key}</a>")

          bindModes: ->
            html = $ '<div></div>'
            append = (key) ->
                node = "<option value='#{key}'>#{key}</option>"
                html.append $(node)
            modes = model.modes
            append key for key of modes
            $('#modes').append html.children() #TODO - why is @modes not seeing 'append'?

          keyDown: (e, view) =>
            modifierKey = e.altKey or e.metaKey or e.ctrlKey
            if not modifierKey
               code = e.charCode || e.keyCode
               if 37 <= code <= 40
                   view.arrowHandler(code)
               else
                   letter = String.fromCharCode code
                   view.keyHandler(letter)

          modelChange: (e) ->
            key = @scale.get('key')
            mode = @scale.get('mode')
            notes = @fretboard.init().drawScale key, mode
            #@staff.draw(notes)
            @navigate 'scale/' + key + '/' + mode
            @paintControls(mode, key)

        Scale = Backbone.Model.extend()

        View = Backbone.View.extend

            initialize: ->

            events:
                'change #root': 'rootHandler'
                'change #modes': 'modeHandler'

            modeHandler: (e) ->
                target = $ e.target
                mode = target.val()
                @model.set mode: mode

            rootHandler: (e) ->
                target = $ e.target
                key = target.val()
                @model.set key: key

            keyMap:
                modes: [
                    'ionian'
                    'dorian'
                    'phrygian'
                    'lydian'
                    'mixolydian'
                    'aeolian'
                    'locrian'
                ]
                modeShortcuts: [
                    'I'
                    'R'
                    'P'
                    'L'
                    'M'
                    'O'
                    'N'
                ]
                keys: ['A', 'B', 'C', 'D', 'E', 'F', 'G']

            arrowHandler: (code) ->
                key = @model.get 'key'
                if code is 37
                    if key.toUpperCase() is 'A'
                        @model.set 'key': 'G'
                    else
                        position = $.inArray(key, @keyMap.keys)
                        @model.set 'key': @keyMap.keys[position - 1]
                    return false

                else if code is 39
                    if key.toUpperCase() is 'G'
                        @model.set 'key': 'A'
                    else
                        position = $.inArray(key, @keyMap.keys)
                        @model.set 'key': @keyMap.keys[position + 1]
                    return false

                else if code is 38
                    currentMode = @model.get 'mode'
                    if currentMode is 'locrian'
                        @model.set 'mode': @keyMap.modes[0]
                    else
                        modeIndex = $.inArray(currentMode, @keyMap.modes)
                        @model.set 'mode': @keyMap.modes[modeIndex + 1]
                    return false

                else if code is 40
                    currentMode = @model.get 'mode'
                    if currentMode is 'ionian'
                        @model.set 'mode': @keyMap.modes[@keyMap.modes.length - 1]
                    else
                        modeIndex = $.inArray(currentMode, @keyMap.modes)
                        @model.set 'mode': @keyMap.modes[modeIndex - 1]
                    return false

            keyHandler: (letter) ->
                if letter in @keyMap.keys
                    key = letter.toUpperCase()
                    @model.set 'key': key
                else
                    modeIndex = $.inArray(letter, @keyMap.modeShortcuts)
                    if modeIndex > -1
                        mode = @keyMap.modes[modeIndex]
                        @model.set 'mode': mode

        @workspace = new Workspace

$('document').ready ->
    fretboard = new fb
    fretboard.main()

String.prototype.capitalize = ->
      return this.charAt(0).toUpperCase() + this.substring(1).toLowerCase()
