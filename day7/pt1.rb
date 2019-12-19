require "./IntCode/IntCodeArray.rb"

FindMaxSignal = -> (int_codes, permutation_set) {
  permutation_set.permutation(5).to_a.map { |combos|
    [
      combos,
      combos.reduce(0) do |next_input, amplifier|
        out = ::IntCodeArray::ArrayIORunner.new(
          int_codes.clone,
          inputs: [amplifier, next_input]
        ).call
        out.last
      end
    ]
  }.max_by { |(combo, signal)| signal }
}

class PausableArrayRunner < ::IntCodeArray::ArrayIORunner

  attr_reader :name

  def initialize(*args, **kwargs)
    super(*args, **kwargs)
    @inputs = kwargs[:inputs]
    @name = kwargs[:name]
  end

  def call(inputs=[])
    @inputs += inputs
    @int_coder.call(
      &proc do |is_after_op:, op_i:, next_index:, **k|
        if is_after_op
          case op_i
            when ::IntCodeArray::OUTPUT, ::IntCodeArray::TERMINATE
              return self.outputs.last
            end
        end
      end
    )
  end
end

class FindMaxFeedbackSignal
  Amps = [:A, :B, :C, :D, :E]

  def call(int_codes, permutation_set)
    permutation_set.map do |combos|
      amp_machines = combos.map.with_index do |phase_setting, index|
        PausableArrayRunner.new(int_codes.clone, inputs: [phase_setting], name: Amps[index])
      end

      amps_ll = LinkedList.from_array(amp_machines, circular: true)
      queue = [amps_ll.head]

      [
        combos,
        queue.reduce(0, &proc { |signal, amp_node|
          amp = amp_node.value
          mac = amp.int_coder
          output = amp.call([signal])

          node = amp_node.next
          while (node.value.int_coder.terminated?) && (node != amp_node)
            node = node.next
          end
          if node != amp_node
            queue.push(node)
          end
          amp_node.value.outputs.last
        })
      ]
    end.max_by { |(combo, signal)| signal }
  end
end

