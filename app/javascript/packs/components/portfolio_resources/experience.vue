<template>
  <div class="bloco-experiencia">
    <h4 class="block-title grey">Experiências</h4>

    <div class="row">
      <div class="input-field col l6 m6 s12">
        <input
          placeholder="Título"
          id="experience-title"
          v-model="experience.title"
          class="font_20 custom-grey-text text-darken-1"
        />
        <label class="active font_20 custom-grey-text text-darken-1">Título</label>
      </div>

      <div class="input-field col l6 m6 s12">
        <input
          placeholder="Empresa"
          id="experience-company"
          v-model="experience.company"
          class="font_20 custom-grey-text text-darken-1"
        />
        <label class="active font_20 custom-grey-text text-darken-1">Empresa</label>
      </div>

      <div class="input-field col l6 m6 s12">
        <textarea
          id="experience-description"
          v-model="experience.description"
          class="font_20 custom-grey-text text-darken-1 materialize-textarea"
        ></textarea>
        <label class="active font_20 custom-grey-text text-darken-1">Descrição</label>
      </div>

      <div class="input-field col l4 m4 s6">
        <input
          data-attribute="start-date"
          v-model="experience.start_date"
          placeholder="Data de Entrada"
          id="experience-start-date"
          class="datepicker-experience font_20 custom-grey-text text-darken-1"
        />
        <label class="active font_20 custom-grey-text text-darken-1">Data de Entrada</label>
      </div>

      <div class="input-field col l4 m4 s6">
        <input
          data-attribute="end_date"
          v-model="experience.end_date"
          placeholder="Data de Saída"
          id="experience-end-date"
          class="datepiker-experience font_20 custom-grey-text text-darken-1"
        />
        <label class="active font_20 custom-grey-text text-darken-1">Data de Saída</label>
      </div>

      <div class="input-field col l4 m4 s6">
        <button type="button" class="btn" id="add-experience" @click="submit()">Adicionar</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["portfolioId"],

  data: () => ({
    experience: {},
    experiences: []
  }),

  created() {
    this.$resource("/portfolios{/id}/experiences")
      .get({ id: this.portfolioId })
      .then(
        response => {
          this.experiences = response.body.response;
        },
        response => {
          M.toast({
            html: "Ocorreu um erro ao carregar as Experências",
            classes: "red"
          });
        }
      );
  },

  mounted() {
    let elems = document.querySelectorAll(".datepicker-experience");
    let vue = this;
    M.Datepicker.init(elems, {
      format: "dd/mm/yy",
      onClose: function() {
        console.log(this);
        let attribute = this.el.dataset.attribute;
        vue.experience[attribute] = this.el.value;
      }
    });
  },

  methods: {
    submit() {
      this.$resource("/portfolios{/id}/experiences")
        .save({ id: this.portfolioId }, { experience: this.experience })
        .then(
          response => {
            this.experiences.push(response.body.resource);
            this.experience = {};
          },
          response => {
            response.body.errors.forEach(error => {
              M.toast({ html: error, classes: "red" });
            });
          }
        );
    },

    removeExperience(experience) {
      this.$resource("/portfolios{/portfolioId}/experiences{/id}")
        .remove({ portfolioId: this.portfolioId, id: experience.id })
        .then(
          response => {
            let indexToRemove = this.experiences.indexOf(experience);
            this.experiences.splice(indexToRemove, 1);
          },
          response => {
            response.body.errors.forEach(error => {
              M.toast({ html: error, classes: "red" });
            });
          }
        );
    },
  }
};
</script>