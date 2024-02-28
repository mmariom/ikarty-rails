(function () {
    const $themeConfig = {
        locale: 'en', // en, da, de, el, es, fr, hu, it, ja, pl, pt, ru, sv, tr, zh
        theme: 'light', // light, dark, system
        menu: 'vertical', // vertical, collapsible-vertical, horizontal
        layout: 'full', // full, boxed-layout
        rtlClass: 'ltr', // rtl, ltr
        animation: '', // animate__fadeIn, animate__fadeInDown, animate__fadeInUp, animate__fadeInLeft, animate__fadeInRight, animate__slideInDown, animate__slideInLeft, animate__slideInRight, animate__zoomIn
        navbar: 'navbar-sticky', // navbar-sticky, navbar-floating, navbar-static
        semidark: false,
    };
    window.addEventListener('load', function () {
        // screen loader
        const screen_loader = document.getElementsByClassName('screen_loader');
        if (screen_loader?.length) {
            screen_loader[0].classList.add('animate__fadeOut');
            setTimeout(() => {
                document.body.removeChild(screen_loader[0]);
            }, 200);
        }

        // set rtl layout
        Alpine.store('app').setRTLLayout();
    });

    // set current year in footer
    const yearEle = document.querySelector('#footer-year');
    if (yearEle) {
        yearEle.innerHTML = new Date().getFullYear();
    }

    // perfect scrollbar
    const initPerfectScrollbar = () => {
        const container = document.querySelectorAll('.perfect-scrollbar');
        for (let i = 0; i < container.length; i++) {
            new PerfectScrollbar(container[i], {
                wheelPropagation: true,
                // suppressScrollX: true,
            });
        }
    };
    initPerfectScrollbar();

    document.addEventListener('alpine:init', () => {
        Alpine.data('collapse', () => ({
            collapse: false,

            collapseSidebar() {
                this.collapse = !this.collapse;
            },
        }));

        Alpine.data('dropdown', (initialOpenState = false) => ({
            open: initialOpenState,

            toggle() {
                this.open = !this.open;
            },
        }));
        Alpine.data('modal', (initialOpenState = false) => ({
            open: initialOpenState,

            toggle() {
                this.open = !this.open;
            },
        }));

        // Magic: $tooltip
        Alpine.magic('tooltip', (el) => (message, placement) => {
            let instance = tippy(el, {
                content: message,
                trigger: 'manual',
                placement: placement || undefined,
                allowHTML: true,
            });

            instance.show();
        });

        Alpine.directive('dynamictooltip', (el, { expression }, { evaluate }) => {
            let string = evaluate(expression);
            tippy(el, {
                content: string.charAt(0).toUpperCase() + string.slice(1),
            });
        });

        // Directive: x-tooltip
        Alpine.directive('tooltip', (el, { expression }) => {
            tippy(el, {
                content: expression,
                placement: el.getAttribute('data-placement') || undefined,
                allowHTML: true,
                delay: el.getAttribute('data-delay') || 0,
                animation: el.getAttribute('data-animation') || 'fade',
                theme: el.getAttribute('data-theme') || '',
            });
        });

        // Magic: $popovers
        Alpine.magic('popovers', (el) => (message, placement) => {
            let instance = tippy(el, {
                content: message,
                placement: placement || undefined,
                interactive: true,
                allowHTML: true,
                // hideOnClick: el.getAttribute("data-dismissable") ? true : "toggle",
                delay: el.getAttribute('data-delay') || 0,
                animation: el.getAttribute('data-animation') || 'fade',
                theme: el.getAttribute('data-theme') || '',
                trigger: el.getAttribute('data-trigger') || 'click',
            });

            instance.show();
        });

        // main - custom functions
        Alpine.data('main', (value) => ({}));

        Alpine.store('app', {
            // theme
            theme: Alpine.$persist($themeConfig.theme),
            isDarkMode: Alpine.$persist(false),
            toggleTheme(val) {
                if (!val) {
                    val = this.theme || $themeConfig.theme; // light|dark|system
                }

                this.theme = val;

                if (this.theme == 'light') {
                    this.isDarkMode = false;
                } else if (this.theme == 'dark') {
                    this.isDarkMode = true;
                } else if (this.theme == 'system') {
                    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
                        this.isDarkMode = true;
                    } else {
                        this.isDarkMode = false;
                    }
                }
            },

            // navigation menu
            menu: Alpine.$persist($themeConfig.menu),
            toggleMenu(val) {
                if (!val) {
                    val = this.menu || $themeConfig.menu; // vertical, collapsible-vertical, horizontal
                }
                this.sidebar = false; // reset sidebar state
                this.menu = val;
            },

            // layout
            layout: Alpine.$persist($themeConfig.layout),
            toggleLayout(val) {
                if (!val) {
                    val = this.layout || $themeConfig.layout; // full, boxed-layout
                }

                this.layout = val;
            },

            // rtl support
            rtlClass: Alpine.$persist($themeConfig.rtlClass),
            toggleRTL(val) {
                if (!val) {
                    val = this.rtlClass || $themeConfig.rtlClass; // rtl, ltr
                }

                this.rtlClass = val;
                this.setRTLLayout();
            },

            setRTLLayout() {
                document.querySelector('html').setAttribute('dir', this.rtlClass || $themeConfig.rtlClass);
            },

            // animation
            animation: Alpine.$persist($themeConfig.animation),
            toggleAnimation(val) {
                if (!val) {
                    val = this.animation || $themeConfig.animation; // animate__fadeIn, animate__fadeInDown, animate__fadeInLeft, animate__fadeInRight
                }

                val = val?.trim();

                this.animation = val;
            },

            // navbar type
            navbar: Alpine.$persist($themeConfig.navbar),
            toggleNavbar(val) {
                if (!val) {
                    val = this.navbar || $themeConfig.navbar; // navbar-sticky, navbar-floating, navbar-static
                }

                this.navbar = val;
            },

            // semidark
            semidark: Alpine.$persist($themeConfig.semidark),
            toggleSemidark(val) {
                if (!val) {
                    val = this.semidark || $themeConfig.semidark;
                }

                this.semidark = val;
            },

            // multi language
            locale: Alpine.$persist($themeConfig.locale),
            toggleLocale(val) {
                if (!val) {
                    val = this.locale || $themeConfig.locale;
                }

                this.locale = val;
                if (this.locale?.toLowerCase() === 'ae') {
		            this.toggleRTL('rtl');
		        } else {
		            this.toggleRTL('ltr');
		        }
            },

            // sidebar
            sidebar: false,
            toggleSidebar() {
                this.sidebar = !this.sidebar;
            },
        });

        Alpine.data("basic", () => ({
            datatable: null,
            init() {
              this.loadDataTable();
            },
            loadDataTable() {
              this.refreshData(); // Initial data load via AJAX
            },
            refreshData() {
              fetch('/cards_data')
                .then(response => response.json())
                .then(data => {
                  const editBasePath = '/upravit/'; // Adjust based on your actual edit path
                  const deleteBasePath = '/odstranit/'; // Adjust based on your actual delete path
                  const cardData = data.map(card => [
                    card.unique_key,
                    truncateText(card.location, 35), // Truncate "Názov" to 35 characters
                    truncateText(card.destination_url, 90),
                      `<a href='${editBasePath}${card.unique_key}' class='edit-btn'>
                       <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="w-6 h-6">
                       <path opacity="0.5" d="M3.27489 15.2957C2.42496 14.1915 2 13.6394 2 12C2 10.3606 2.42496 9.80853 3.27489 8.70433C4.97196 6.49956 7.81811 4 12 4C16.1819 4 19.028 6.49956 20.7251 8.70433C21.575 9.80853 22 10.3606 22 12C22 13.6394 21.575 14.1915 20.7251 15.2957C19.028 17.5004 16.1819 20 12 20C7.81811 20 4.97196 17.5004 3.27489 15.2957Z" stroke="currentColor" stroke-width="1.5"></path>
                       <path d="M15 12C15 13.6569 13.6569 15 12 15C10.3431 15 9 13.6569 9 12C9 10.3431 10.3431 9 12 9C13.6569 9 15 10.3431 15 12Z" stroke="currentColor" stroke-width="1.5"></path>
                        </svg>
                      </a> 
                    `
                  ]);
                  // Check if datatable is already initialized
                  if (this.datatable) {
                    // Clear and reload the datatable with new data
                    this.datatable.clear().rows.add(cardData).draw();
                  } else {
                    // Initialize the DataTable with the fetched data
                    this.datatable = new simpleDatatables.DataTable('#myTable', {
                      data: {
                        headings: ["ID karty", "Názov", "URL adresa presmerovania", "Zobraziť"],
                        data: cardData
                      },
                      sortable: false,
                      searchable: true,
                      perPage: 10,
                      perPageSelect: [10, 20, 30, 50, 100],
                      firstLast: true,
                      firstText: '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="w-4.5 h-4.5 rtl:rotate-180"> <path d="M13 19L7 12L13 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/> <path opacity="0.5" d="M16.9998 19L10.9998 12L16.9998 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/> </svg>',
                      lastText: '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="w-4.5 h-4.5 rtl:rotate-180"> <path d="M11 19L17 12L11 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/> <path opacity="0.5" d="M6.99976 19L12.9998 12L6.99976 5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/> </svg>',
                      prevText: '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="w-4.5 h-4.5 rtl:rotate-180"> <path d="M15 5L9 12L15 19" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/> </svg>',
                      nextText: '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="w-4.5 h-4.5 rtl:rotate-180"> <path d="M9 5L15 12L9 19" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/> </svg>',
                      labels: {
                        perPage: "{select}"
                      },
                      layout: {
                        top: "{search}",
                        bottom: "{info}{select}{pager}"
                      }
                    
                    });
                  }
                });
            }
          }));
    });
})();
