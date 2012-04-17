###*
  @fileoverview DOM utils.
###

goog.provide 'este.dom'

goog.require 'goog.dom'
goog.require 'goog.string'

`
/**
  Extracted and modified goog.dom.query getQueryParts method.
  todo: rewrite into def object?
  Returns [
    query: null, // the full text of the part's rule
    pseudos: [], // CSS supports multiple pseudo-class matches in a single
        // rule
    attrs: [],  // CSS supports multi-attribute match, so we need an array
    classes: [], // class matches may be additive,
        // e.g.: .thinger.blah.howdy
    tag: null,  // only one tag...
    oper: null, // ...or operator per component. Note that these wind up
        // being exclusive.
    id: null   // the id component of a rule
  , ..
  ]
  @private
*/
este.dom.getQueryPartsCache_ = {};
este.dom.getQueryParts = function(query) {
  var queryKey = query;
  var cached = este.dom.getQueryPartsCache_[queryKey];
  if (cached) {
    return cached;
  }

  //  summary:
  //    state machine for query tokenization
  //  description:
  //    instead of using a brittle and slow regex-based CSS parser,
  //    dojo.query implements an AST-style query representation. This
  //    representation is only generated once per query. For example,
  //    the same query run multiple times or under different root nodes
  //    does not re-parse the selector expression but instead uses the
  //    cached data structure. The state machine implemented here
  //    terminates on the last " " (space) character and returns an
  //    ordered array of query component structures (or "parts"). Each
  //    part represents an operator or a simple CSS filtering
  //    expression. The structure for parts is documented in the code
  //    below.


  // NOTE:
  //    this code is designed to run fast and compress well. Sacrifices
  //    to readability and maintainability have been made.
  if ('>~+'.indexOf(query.slice(-1)) >= 0) {
    // If we end with a ">", "+", or "~", that means we're implicitly
    // searching all children, so make it explicit.
    query += ' * '
  } else {
    // if you have not provided a terminator, one will be provided for
    // you...
    query += ' ';
  }

  var ts = function(/*Integer*/ s, /*Integer*/ e) {
    // trim and slice.

    // take an index to start a string slice from and an end position
    // and return a trimmed copy of that sub-string
    return goog.string.trim(query.slice(s, e));
  };

  // The overall data graph of the full query, as represented by queryPart
  // objects.
  var queryParts = [];


  // state keeping vars
  var inBrackets = -1,
      inParens = -1,
      inMatchFor = -1,
      inPseudo = -1,
      inClass = -1,
      inId = -1,
      inTag = -1,
      lc = '',
      cc = '',
      pStart;

  // iteration vars
  var x = 0, // index in the query
      ql = query.length,
      currentPart = null, // data structure representing the entire clause
      cp = null; // the current pseudo or attr matcher

  // several temporary variables are assigned to this structure during a
  // potential sub-expression match:
  //    attr:
  //      a string representing the current full attribute match in a
  //      bracket expression
  //    type:
  //      if there's an operator in a bracket expression, this is
  //      used to keep track of it
  //    value:
  //      the internals of parenthetical expression for a pseudo. for
  //      :nth-child(2n+1), value might be '2n+1'

  var endTag = function() {
    // called when the tokenizer hits the end of a particular tag name.
    // Re-sets state variables for tag matching and sets up the matcher
    // to handle the next type of token (tag or operator).
    if (inTag >= 0) {
      var tv = (inTag == x) ? null : ts(inTag, x);
      if ('>~+'.indexOf(tv) < 0) {
        currentPart.tag = tv;
      } else {
        currentPart.oper = tv;
      }
      inTag = -1;
    }
  };

  var endId = function() {
    // Called when the tokenizer might be at the end of an ID portion of a
    // match.
    if (inId >= 0) {
      currentPart.id = ts(inId, x).replace(/\\/g, '');
      inId = -1;
    }
  };

  var endClass = function() {
    // Called when the tokenizer might be at the end of a class name
    // match. CSS allows for multiple classes, so we augment the
    // current item with another class in its list.
    if (inClass >= 0) {
      currentPart.classes.push(ts(inClass + 1, x).replace(/\\/g, ''));
      inClass = -1;
    }
  };

  var endAll = function() {
    // at the end of a simple fragment, so wall off the matches
    endId(); endTag(); endClass();
  };

  var endPart = function() {
    endAll();
    if (inPseudo >= 0) {
      currentPart.pseudos.push({ name: ts(inPseudo + 1, x) });
    }
    // Hint to the selector engine to tell it whether or not it
    // needs to do any iteration. Many simple selectors don't, and
    // we can avoid significant construction-time work by advising
    // the system to skip them.
    currentPart.loops = currentPart.pseudos.length ||
                        currentPart.attrs.length ||
                        currentPart.classes.length;

    // save the full expression as a string
    currentPart.oquery = currentPart.query = ts(pStart, x);


    // otag/tag are hints to suggest to the system whether or not
    // it's an operator or a tag. We save a copy of otag since the
    // tag name is cast to upper-case in regular HTML matches. The
    // system has a global switch to figure out if the current
    // expression needs to be case sensitive or not and it will use
    // otag or tag accordingly
    currentPart.otag = currentPart.tag = (currentPart.oper) ?
                                                   null :
                                                   (currentPart.tag || '*');

    if (currentPart.tag) {
      // if we're in a case-insensitive HTML doc, we likely want
      // the toUpperCase when matching on element.tagName. If we
      // do it here, we can skip the string op per node
      // comparison
      currentPart.tag = currentPart.tag.toUpperCase();
    }

    // add the part to the list
    if (queryParts.length && (queryParts[queryParts.length - 1].oper)) {
      // operators are always infix, so we remove them from the
      // list and attach them to the next match. The evaluator is
      // responsible for sorting out how to handle them.
      currentPart.infixOper = queryParts.pop();
      currentPart.query = currentPart.infixOper.query + ' ' +
          currentPart.query;
    }
    queryParts.push(currentPart);

    currentPart = null;
  }

  // iterate over the query, character by character, building up a
  // list of query part objects
  for (; lc = cc, cc = query.charAt(x), x < ql; x++) {
    //    cc: the current character in the match
    //    lc: the last character (if any)

    // someone is trying to escape something, so don't try to match any
    // fragments. We assume we're inside a literal.
    if (lc == '\\') {
      continue;
    }
    if (!currentPart) { // a part was just ended or none has yet been created
      // NOTE: I hate all this alloc, but it's shorter than writing tons of
      // if's
      pStart = x;
      //  rules describe full CSS sub-expressions, like:
      //    #someId
      //    .className:first-child
      //  but not:
      //    thinger > div.howdy[type=thinger]
      //  the individual components of the previous query would be
      //  split into 3 parts that would be represented a structure
      //  like:
      //    [
      //      {
      //        query: 'thinger',
      //        tag: 'thinger',
      //      },
      //      {
      //        query: 'div.howdy[type=thinger]',
      //        classes: ['howdy'],
      //        infixOper: {
      //          query: '>',
      //          oper: '>',
      //        }
      //      },
      //    ]
      currentPart = {
        query: null, // the full text of the part's rule
        pseudos: [], // CSS supports multiple pseudo-class matches in a single
            // rule
        attrs: [],  // CSS supports multi-attribute match, so we need an array
        classes: [], // class matches may be additive,
            // e.g.: .thinger.blah.howdy
        tag: null,  // only one tag...
        oper: null, // ...or operator per component. Note that these wind up
            // being exclusive.
        id: null   // the id component of a rule
      };

      // if we don't have a part, we assume we're going to start at
      // the beginning of a match, which should be a tag name. This
      // might fault a little later on, but we detect that and this
      // iteration will still be fine.
      inTag = x;
    }

    if (inBrackets >= 0) {
      // look for a the close first
      if (cc == ']') { // if we're in a [...] clause and we end, do assignment
        if (!cp.attr) {
          // no attribute match was previously begun, so we
          // assume this is an attribute existence match in the
          // form of [someAttributeName]
          cp.attr = ts(inBrackets + 1, x);
        } else {
          // we had an attribute already, so we know that we're
          // matching some sort of value, as in [attrName=howdy]
          cp.matchFor = ts((inMatchFor || inBrackets + 1), x);
        }
        var cmf = cp.matchFor;
        if (cmf) {
          // try to strip quotes from the matchFor value. We want
          // [attrName=howdy] to match the same
          //  as [attrName = 'howdy' ]
          if ((cmf.charAt(0) == '"') || (cmf.charAt(0) == "'")) {
            cp.matchFor = cmf.slice(1, -1);
          }
        }
        // end the attribute by adding it to the list of attributes.
        currentPart.attrs.push(cp);
        cp = null; // necessary?
        inBrackets = inMatchFor = -1;
      } else if (cc == '=') {
        // if the last char was an operator prefix, make sure we
        // record it along with the '=' operator.
        var addToCc = ('|~^$*'.indexOf(lc) >= 0) ? lc : '';
        cp.type = addToCc + cc;
        cp.attr = ts(inBrackets + 1, x - addToCc.length);
        inMatchFor = x + 1;
      }
      // now look for other clause parts
    } else if (inParens >= 0) {
      // if we're in a parenthetical expression, we need to figure
      // out if it's attached to a pseudo-selector rule like
      // :nth-child(1)
      if (cc == ')') {
        if (inPseudo >= 0) {
          cp.value = ts(inParens + 1, x);
        }
        inPseudo = inParens = -1;
      }
    } else if (cc == '#') {
      // start of an ID match
      endAll();
      inId = x + 1;
    } else if (cc == '.') {
      // start of a class match
      endAll();
      inClass = x;
    } else if (cc == ':') {
      // start of a pseudo-selector match
      endAll();
      inPseudo = x;
    } else if (cc == '[') {
      // start of an attribute match.
      endAll();
      inBrackets = x;
      // provide a new structure for the attribute match to fill-in
      cp = {
        /*=====
        attr: null, type: null, matchFor: null
        =====*/
      };
    } else if (cc == '(') {
      // we really only care if we've entered a parenthetical
      // expression if we're already inside a pseudo-selector match
      if (inPseudo >= 0) {
        // provide a new structure for the pseudo match to fill-in
        cp = {
          name: ts(inPseudo + 1, x),
          value: null
        }
        currentPart.pseudos.push(cp);
      }
      inParens = x;
    } else if (
      (cc == ' ') &&
      // if it's a space char and the last char is too, consume the
      // current one without doing more work
      (lc != cc)
    ) {
      endPart();
    }
  }
  return este.dom.getQueryPartsCache_[queryKey] = queryParts;
};
`

###*
  Element matcher for getQueryParts.
  @param {Element} el
  @param {string} matcher
  @return {boolean}
###
este.dom.matchQueryParts = (el, matcher) ->
  queryParts = este.dom.getQueryParts matcher
  for part in queryParts
    return false if part.tag && el.tagName != part.tag
    return false if part.id && el.id != part.id
    for className in part.classes
      return false if !goog.dom.classes.has el, className
  true

###*
  Get element ancestors.
  @param {Node} el
  @param {boolean=} opt_includeNode
  @param {boolean=} opt_stopOnBody
  @return {Array.<Element>}
###
este.dom.getAncestors = (el, opt_includeNode, opt_stopOnBody) ->
  els = []
  el = el.parentNode if !opt_includeNode
  while el
    break if opt_stopOnBody && el.tagName == 'BODY'
    els.push el
    el = el.parentNode
  els

###*
  @param {Array.<Element>} elements
###
este.dom.getDomPath = (elements) ->
  path = []
  for element in elements
    path.push element.tagName.toUpperCase()
    path.push '#', element.id if element.id
    for className in goog.dom.classes.get element
      path.push '.', className
    path.push ' '
  path.pop()
  path.join ''

###*
  @param {Element} newNode
  @param {Element} refNode
  @param {string} where before, after, prepend, append
###
este.dom.insert = (newNode, refNode, where) ->
  switch where
    when 'before'
      goog.dom.insertSiblingBefore newNode, refNode
    when 'after'
      goog.dom.insertSiblingAfter newNode, refNode
    when 'prepend'
      goog.dom.insertChildAt refNode, newNode, 0
    when 'append'
      goog.dom.appendChild refNode, newNode
  return

















