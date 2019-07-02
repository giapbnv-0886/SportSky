module ApplicationHelper

  def full_title(page_title)
    base_title = I18n.t "base_title"
    if page_title.empty?
      return base_title
    else
      return page_title + '|' + base_title
    end
  end

  def link_to_add_fields name, f, association
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for association, new_object, child_index: id do |builder|
      render association.to_s.singularize + "_fields", f: builder
    end
    link_to name, '#', class: "add_fields btn btn-primary",
      data: {id: id, fields: fields.gsub("\n", "")}
  end

  def link_to_remove_fields name, f, html_options={}
    default_options= { class: "remove_fields btn btn-danger" }
    default_options.reverse_merge!(html_options)
    f.hidden_field(:_destroy) + link_to(name, "#", html_options = default_options )
  end

  def create_timeframe s_time, e_time, step
    unless step > 0
      flash[:danger] = t "pitch.alert.step_error"
      redirect_to root_path
    end
    timeframes = []
    i = 0
    while s_time + (i*step).hours < e_time
      s= s_time + (i*step).hours
      i+=1
      e= s_time + (i*step).hours
      timeframes << [s,e]
    end
    return timeframes
  end

  def time_frames_params f, association, time_frame
      new_object = f.object.send(association).klass.new starttime: time_frame[0], endtime: time_frame[1]
      id = new_object.object_id
      fields =f.fields_for association, new_object, child_index: id do |builder|
        render association.to_s.singularize + "_fields", f: builder
      end
  end
end
