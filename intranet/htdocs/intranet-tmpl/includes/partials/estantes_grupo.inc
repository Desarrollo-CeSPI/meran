[% USE HTML %]

<div class="accordion grupo_estantes_[% id2 %]" id="grupo_estantes_[% id2 %]">
            <div class="accordion-group">
              <div class="accordion-heading">
                <a class="accordion-toggle" data-toggle="collapse" data-parent="#grupo_estantes_[% id2 %]" href="#estantes_[% id2 %]">
                  [% "Estantes virtuales del grupo"| i18n %]
                </a>
              </div>
			<div id="estantes_[% id2 %]" class="accordion-body collapse estantes_[% id2 %]">
					<div id="estantes_inner[% id2 %]" class="accordion-inner"></div>	
			</div>
		</div>
</div>
