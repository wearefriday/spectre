function AnchorScroll(elems) {
  this.init(elems);
}

AnchorScroll.prototype.init = function (elems) {
  var self = this;
  var buttons = [];

  $.each($('.test__set-baseline'), function(index, elem) {
    buttons.push(new AnchoredButton(elem));
  });

  $(window).scroll(function() {
    self.updateButtons(this.scrollY, buttons);
  });
};

AnchorScroll.prototype.updateButtons = function (windowY, buttons) {
  $.each(buttons, function (index, button) {
    button.update(windowY);
  });
};

function AnchoredButton(elem) {
  this.elem = $(elem);
  this.stickyClassName = 'test__set-baseline--sticky';
  this.stickyBottomClassName = 'test__set-baseline--sticky-bottom';
  var container = this.elem.parents('tr');
  var marginTop = 10;
  var marginBottom = 86;
  this.startAnchorPoint = this.elem.offset().top - marginTop;
  this.endAnchorPoint = container.position().top + container.height() - marginBottom;
}

AnchoredButton.prototype.update = function (windowY) {
  if(windowY < this.startAnchorPoint) {
    this.elem.removeClass(this.stickyClassName);
    this.elem.removeClass(this.stickyBottomClassName);
  }

  if(windowY > this.startAnchorPoint && windowY < this.endAnchorPoint) {
    this.elem.addClass(this.stickyClassName);
    this.elem.removeClass(this.stickyBottomClassName);
  }

  if(windowY > this.endAnchorPoint) {
    this.elem.addClass(this.stickyBottomClassName);
    this.elem.removeClass(this.stickyClassName);
  }

};
